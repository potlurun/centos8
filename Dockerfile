FROM centos:latest
MAINTAINER “Narahari” <p_narahari@yahoo.com>
LABEL description="A basic CentOS Container with php and nginx"
# ARG SSH_KEY1
# ARG SSH_KEY2
ENV container docker
# ENV SSH_KEY1=$SSH_KEY1
# ENV SSH_KEY2=$SSH_KEY2
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* ; \
        sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* ; \
#       yum -y update; \
        yum install -y --setopt=tsflags=nodocs systemd openssh-server php nginx firewalld sudo; yum clean all
RUN useradd -u3000 student; echo student:student123 | chpasswd; \
        mkdir -m 700 -p /home/student/.ssh; chown student:student /home/student/.ssh; \
        useradd -u3456 hari; echo hari:hari123 | chpasswd; \
        mkdir -m 700 -p /home/hari/.ssh; chown hari:hari /home/hari/.ssh
# RUN echo "$SSH_KEY1" > /home/hari/.ssh/authorized_keys; chown hari:hari /home/hari/.ssh/authorized_keys
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
        rm -f /lib/systemd/system/multi-user.target.wants/*; \
        rm -f /etc/systemd/system/*.wants/*; \
        rm -f /lib/systemd/system/local-fs.target.wants/*; \
        rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
        rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
        rm -f /lib/systemd/system/basic.target.wants/*; \
        rm -f /lib/systemd/system/anaconda.target.wants/*
RUN ln -s /usr/lib/systemd/system/sshd.service /etc/systemd/system/multi-user.target.wants/sshd.service; \
        ln -s /usr/lib/systemd/system/nginx.service /etc/systemd/system/multi-user.target.wants/nginx.service; \
        ln -s /usr/lib/systemd/system/firewalld.service /etc/systemd/system/multi-user.target.wants/firewalld.service; \
        ln -s /usr/lib/systemd/system/systemd-user-sessions.service /etc/systemd/system/multi-user.target.wants/systemd-user-sessions.service; \
        mkdir -p /etc/sudoers.d; \
        echo "hari ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/hari; \
        echo "<?php" > /usr/share/nginx/html/index.php; \
        echo "echo \"This page is from ... \";" >> /usr/share/nginx/html/index.php; \
        echo "echo gethostname();" >> /usr/share/nginx/html/index.php; \
        echo " "  >> /usr/share/nginx/html/index.php ; \
        echo "?>" >> /usr/share/nginx/html/index.php
EXPOSE 80
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
