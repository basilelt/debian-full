FROM debian:latest

RUN apt-get update && apt-get install -y locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV PATH="/root/.cargo/bin:${PATH}" \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        python3-venv \
        htop curl wget net-tools tcpdump git vim nano python3 python3-pip jq \
        less coreutils dstat tshark iproute2 gcc libgtk-3-0 lldb ssh \
        openssh-server sudo nodejs autossh postgresql subversion tmux zsh \
        man-db iputils-ping nmap iptables rsync x11-apps xauth xclip\
        libssl-dev pkg-config && \
    apt-get clean && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    useradd -m -s /bin/zsh toto && \
    usermod -aG sudo toto && \
    echo 'toto:toto' | chpasswd && \
    mkdir -p /home/toto/data && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    python3 -m venv /home/toto/.venv && \
    /home/toto/.venv/bin/pip install --no-cache-dir ansible && \
    mkdir /var/run/sshd && \
    sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd && \
    echo "X11Forwarding yes" >> /etc/ssh/sshd_config && \
    mkdir -p /home/toto/.ssh && \
    chmod 700 /home/toto/.ssh && \
    touch /home/toto/.ssh/authorized_keys && \
    chmod 600 /home/toto/.ssh/authorized_keys && \
    chown -R toto:toto /home/toto/.ssh && \
    su - toto -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended' && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/toto/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    echo '# If you come from bash you might have to change your $PATH.\n\
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH\n\
\n\
# Path to your Oh My Zsh installation.\n\
export ZSH="$HOME/.oh-my-zsh"\n\
\n\
ZSH_THEME="agnoster"\n\
\n\
plugins=(git zsh-syntax-highlighting)\n\
\n\
source $ZSH/oh-my-zsh.sh\n\
source /home/toto/.venv/bin/activate\n\
\n\
PROMPT="%F{cyan}%n%f@%F{green}%m%f %F{yellow}%~%f %# "\n\
alias ls="ls --color=auto"\n\
\n\
alias c="clear"\n\
alias ll="ls -la"\n\
alias ex="exit"\n\
alias pbcopy="xclip -selection clipboard"\n\
alias pbpaste="xclip -selection clipboard -o"' > /home/toto/.zshrc && \
    chown toto:toto /home/toto/.zshrc

WORKDIR /home/toto

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22 443 80

CMD ["/start.sh"]