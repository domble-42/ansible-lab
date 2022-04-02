# syntax=docker/dockerfile:1
FROM debian:bullseye-slim

LABEL maintainer="github@clonix.info"

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update \
    && apt-get upgrade -qq -y \
    && apt-get install --no-install-recommends --no-install-suggests -qq -y \
        openssh-server \
        python3 \
        python3-pip \
        sshpass \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install ansible

RUN mkdir /var/run/sshd \
    mkdir /root/playbooks \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN echo 'root:toor' | chpasswd
EXPOSE 22

WORKDIR /root/playbooks/
CMD ["/usr/sbin/sshd", "-D"]
