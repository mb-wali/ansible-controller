# used to copy ssh folder from vms
# to be able to access the vms passwordless
FROM mbwali/centos7-vms:latest AS builder

FROM centos:7

# Install systemd -- See https://hub.docker.com/_/centos/
RUN yum -y update; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install requirements.
RUN yum makecache fast \
 && yum -y install deltarpm epel-release initscripts \
 && yum -y update \
 && yum -y install \
      sudo \
      which \
      openssh openssh-server openssh-clients \
      python \
      python-pip \
      python-setuptools \
      git \
      python-netaddr \
      python-dns \
      dmidecode rpm-build jq \
      docker-compose \
      nano \
 && yum clean all

# Upgrade Pip so cryptography package works.
RUN python -m pip install --upgrade pip==20.3.4

# Install packages via Pip.
RUN python -m pip install docker requests python-irodsclient

# Install docker
RUN yum install -y yum-utils device-mapper-persistent-data lvm2
RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
RUN yum install docker-ce -y

# Disable requiretty.
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Install Ansible
RUN yum install -y epel-release -y
RUN yum install -y ansible

# copy .ssh folder from vms
COPY --from=builder /root/.ssh/* /root/.ssh/

VOLUME ["/sys/fs/cgroup"]
ENTRYPOINT ["/usr/sbin/init"]
