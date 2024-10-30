FROM debian:bookworm
MAINTAINER Adrian Dvergsdal [atmoz.net]

# Steps done in one RUN layer:
# - Install upgrades and new packages
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" apt-get -y install --no-install-recommends openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key*

COPY files/sshd_config /etc/ssh/sshd_config
COPY files/create-sftp-user /usr/local/bin/
COPY files/entrypoint /
RUN chgrp -R 0 /etc/sftp /var/run /usr/loca/bin /etc/sftp.d && \
    chmod -R 770 /etc/sftp /var/run /usr/loca/bin /etc/sftp.d

EXPOSE 22

ENTRYPOINT ["/entrypoint"]
