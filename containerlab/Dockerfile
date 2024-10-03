# Use Debian Bullseye as the base image
FROM debian:latest

# Set the containerlab version
ARG CLAB_VERSION=0.57.5

# Install basic tools and dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y sshpass openssh-server curl iputils-ping \
    coreutils htop yamllint docker.io ca-certificates sudo && \
    apt-get clean && \
    useradd -m -s /bin/bash clab-user && \
    usermod -aG sudo clab-user && \
    usermod -aG docker clab-user && \
    echo 'clab-user:toto' | chpasswd && \
    mkdir -p /home/clab-user/data && \
    mkdir /var/run/sshd && \
    sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd && \
    echo "X11Forwarding yes" >> /etc/ssh/sshd_config && \
    mkdir -p /home/clab-user/.ssh && \
    chmod 700 /home/clab-user/.ssh && \
    touch /home/clab-user/.ssh/authorized_keys && \
    chmod 600 /home/clab-user/.ssh/authorized_keys && \
    chown -R clab-user:clab-user /home/clab-user/.ssh

RUN bash -c "$(curl -sL https://get.containerlab.dev)" -- -v ${CLAB_VERSION}

WORKDIR /home/clab-user

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22

CMD ["/start.sh"]