FROM debian:latest

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
    htop \
    curl \
    wget \
    net-tools \
    tcpdump \
    git \
    vim \
    nano \
    python3 \
    python3-pip \
    jq \
    less \
    coreutils \
    dstat \
    tshark \
    iproute2 \
    gcc \
    libgtk-3-0 \
    lldb \
    ssh \
    openssh-server \
    sudo \
    nodejs \
    autossh \
    postgresql \
    subversion \
    tmux \
    zsh \
    man-db \
    iputils-ping \
    nmap \
    iptables \
    rsync

RUN useradd -m -s /bin/zsh toto && \
    usermod -aG sudo toto && \
    echo 'toto:toto' | chpasswd

WORKDIR /home/toto

RUN mkdir data

RUN python3 -m venv .venv && \
    . .venv/bin/activate && \
    pip install --no-cache-dir ansible

RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Set up SSH key authentication
RUN mkdir -p /home/toto/.ssh && \
    chmod 700 /home/toto/.ssh && \
    touch /home/toto/.ssh/authorized_keys && \
    chmod 600 /home/toto/.ssh/authorized_keys && \
    chown -R toto:toto /home/toto/.ssh

# Create a startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22

CMD ["/start.sh"]