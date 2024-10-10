# Use the official Docker-in-Docker image
FROM docker:dind

# Set the containerlab version
ARG CLAB_VERSION=0.57.5

# Copy start.sh
COPY start.sh /start.sh

# Install basic tools and dependencies
RUN apk update && \
    apk add --no-cache \
    openssh-server \
    sshpass \
    curl \
    iputils \
    coreutils \
    htop \
    yamllint \
    sudo \
    bash && \
    # Create a user and set password
    adduser -D -h /home/clab-user -s /bin/sh clab-user && \
    echo 'clab-user:toto' | chpasswd && \
    # Add user to sudoers
    echo "clab-user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    # Add user to docker group
    addgroup clab-user docker && \
    # Setup SSH
    mkdir -p /var/run/sshd && \
    mkdir -p /home/clab-user/.ssh && \
    chown clab-user:clab-user /home/clab-user/.ssh && \
    chmod 700 /home/clab-user/.ssh && \
    touch /home/clab-user/.ssh/authorized_keys && \
    chown clab-user:clab-user /home/clab-user/.ssh/authorized_keys && \
    chmod 600 /home/clab-user/.ssh/authorized_keys && \
    # Configure SSH
    sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "X11Forwarding yes" >> /etc/ssh/sshd_config && \
    ssh-keygen -A && \
    # Install containerlab
    bash -c "$(curl -sL https://get.containerlab.dev)" -- -v ${CLAB_VERSION} && \
    # Set permissions
    chmod +x /start.sh && \
    chown root:root /start.sh && \
    # cleanup
    rm -rf /var/cache/apk/*

# Expose SSH port
EXPOSE 22

# Start the entrypoint script
ENTRYPOINT ["/start.sh"]
