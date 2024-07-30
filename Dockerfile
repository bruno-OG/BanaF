FROM almalinux:9.4

# Get things from host system
ARG UID
ARG GID
COPY ./authorized_keys /authorized_keys

# Install packages
RUN dnf -y update
RUN dnf -y install -y openssh-server
RUN dnf -y install vim

RUN dnf -y install https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm
RUN dnf -y install cvmfs
RUN dnf -y install python3
RUN dnf -y install python3-pip
RUN dnf -y install vim
RUN dnf -y install tmux

RUN chmod 755 /etc/ssh
RUN chmod 655 /etc/ssh/*

RUN /usr/bin/ssh-keygen -A

RUN useradd test
RUN echo 'test:test' | chpasswd

RUN mkdir -p /home/test/.ssh
RUN mv /authorized_keys /home/test/.ssh/authorized_keys
RUN chown -R test:test /home/test/.ssh
RUN chmod 700 /home/test/.ssh


RUN /usr/sbin/sshd -p 420 -h /etc/ssh/ssh_host_rsa_key
EXPOSE 420

CMD ["/usr/sbin/sshd","-D"]
