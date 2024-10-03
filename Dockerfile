FROM debian:latest

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        python3-venv \
        htop curl wget net-tools tcpdump git vim nano python3 python3-pip jq \
        less coreutils dstat tshark iproute2 gcc libgtk-3-0 lldb ssh \
        openssh-server sudo nodejs autossh postgresql subversion tmux zsh \
        man-db iputils-ping nmap iptables rsync && \
    useradd -m -s /bin/zsh toto && \
    usermod -aG sudo toto && \
    echo 'toto:toto' | chpasswd && \
    mkdir -p /home/toto/data && \
    python3 -m venv /home/toto/.venv && \
    /home/toto/.venv/bin/pip install --no-cache-dir ansible && \
    mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd && \
    mkdir -p /home/toto/.ssh && \
    chmod 700 /home/toto/.ssh && \
    touch /home/toto/.ssh/authorized_keys && \
    chmod 600 /home/toto/.ssh/authorized_keys && \
    chown -R toto:toto /home/toto/.ssh && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/toto

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22

CMD ["/start.sh"]