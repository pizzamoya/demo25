#!/bin/bash
history -c 
set +o history
> ~/.bash_history
> /root/.bash_history
echo "export HISTCONTROL=ignorespace:ignoredups" >> ~/.bashrc
source ~/.bashrc
usermod -aG wheel root
chmod +x test1.sh
apt-get remove -y git
cd .. 
rm -rf demo25
set -o history
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
apt-get update
useradd -u 1010 -m -s /bin/bash sshuser
echo -e "P@ssw0rd\nP@ssw0rd" | passwd sshuser
usermod -aG wheel sshuser
echo "sshuser ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
cat <<EOF > /etc/openssh/sshd_config
#       $OpenBSD: sshd_config,v 1.103 2018/04/09 20:41:22 tj Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/bin:/usr/bin:/usr/local/bin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

Port 2024
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/openssh/ssh_host_rsa_key
#HostKey /etc/openssh/ssh_host_ecdsa_key
#HostKey /etc/openssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
AllowUsers sshuser
#SyslogFacility AUTHPRIV
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin without-password
#StrictModes yes
MaxAuthTries 2
#MaxSessions 10

PubkeyAuthentication yes
#PubkeyAcceptedKeyTypes ssh-ed25519-cert-v01@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256,ssh-rsa-cert-v01@openssh.com,ssh-rsa,ecdsa-sha2-nistp521-cert-v01@openssh.com,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp521,ecdsa-sha2-nistp384,ecdsa-sha2-nistp256

#AuthorizedKeysFile     /etc/openssh/authorized_keys/%u /etc/openssh/authorized_keys2/%u .ssh/authorized_keys .ssh/authorized_keys2

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/openssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication yes
#PermitEmptyPasswords no

# Change to yes to enable s/key passwords
#ChallengeResponseAuthentication no

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
#UsePAM yes

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
#X11Forwarding yes
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
Banner /etc/openssh/banner

# override default of no subsystems
Subsystem       sftp    /usr/lib/openssh/sftp-server

#AllowGroups wheel users

# Accept locale environment variables
AcceptEnv LANG LANGUAGE LC_ADDRESS LC_ALL LC_COLLATE LC_CTYPE
AcceptEnv LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES LC_MONETARY
AcceptEnv LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE LC_TIME

# Example of overriding settings on a per-user basis
#Match User anoncvs
#       X11Forwarding yes
#       AllowTcpForwarding no
#       PermitTTY no
#       ForceCommand cvs server
#Match Group secured
#       AuthorizedKeysFile /etc/openssh/authorized_keys/%u
#Match Group !secured,*
#       AuthorizedKeysFile /etc/openssh/authorized_keys/%u .ssh/authorized_keys
EOF
set -o history
systemctl restart sshd
apt-get install -y chrony
 set +o history
 cat <<EOF > /etc/chrony.conf
# Use public server from the pool
# Please consider joining the pool
server 172.16.5.1
EOF
 set -o history
systemctl restart chronyd
cat <<EOF >> /etc/resolv.conf
nameserver 192.168.1.62
nameserver 8.8.8.8
EOF
apt-get update && apt-get install -y task-samba-dc bind-utils
for service in smb nmb krb5kdc slapd bind;
do
 systemctl disable $service --now;
done
rm -f /etc/samba/smb.conf
rm -rf /var/lib/samba
rm -rf /var/cache/samba
mkdir -p /var/lib/samba/sysvol
samba-tool domain provision --realm=au-team.irpo --domain=au-team --adminpass='P@ssw0rd' --dns-backend=SAMBA_INTERNAL --option="dns forwarder=77.88.8.8" --server-role=dc
systemctl enable --now samba
cp /var/lib/samba/private/krb5.conf /etc/krb5.conf
systemctl restart samba
samba-tool domain info 127.0.0.1
echo "search au-team.irpo" > /etc/net/ifaces/ens18/resolv.conf
echo "nameserver 127.0.0.1" >> /etc/net/ifaces/ens18/resolv.conf
echo "nameserver 192.168.1.62" >> /etc/net/ifaces/ens18/resolv.conf
systemctl restart network
samba-tool group add hq
for i in {1..5}; 
do
  samba-tool user add user$i.hq P@ssw0rd;
  samba-tool user setexpiry user$i.hq --noexpiry;
  samba-tool group addmembers "hq" user$i.hq;
done
apt-get install -y admx-*
apt-get install -y ansible sshpass
sed '14i\ inventory = /etc/ansible/hosts' /etc/ansible/ansible.cfg
sed '15i\ host_key_checking = False' /etc/ansible/ansible.cfg
cat <<EOF > /etc/ansible/hosts
HQ-RTR ansible_host=192.168.1.1 ansible_user=net_admin ansible_password=P@ssword ansible_connection=network_cli ansible_network_os=ios
BR-RTR ansible_host=192.168.0.1 ansible_user=net_admin  ansible_password=P@ssword ansible_connection=network_cli ansible_network_os=ios
HQ-SRV ansible_host=192.168.1.62 ansible_user=sshuser ansible_password=P@ssw0rd ansible_ssh_port=2024
HQ-CLI ansible_host=192.168.1.66 ansible_user=user ansible_password=resu

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF
apt-get install -y docker-{engine,compose-v2}
systemctl enable --now docker.service
mkdir /root/docker
cd /root/docker
cat <<EOF > /root/docker/wiki.yml
services:
  Mediawiki:
    container_name: wiki
    image: mediawiki
    restart: always
    ports:
      - 8080:80
    links:
      - mariadb
    volumes:
      - images:/var/www/html/images
      # - ./LocalSettings.php:/var/www/html/LocalSettings.php

  mariadb:
    container_name: mariadb
    image: mariadb
    restart: always
    environment:
      MYSQL_DATABASE: mediawiki
      MYSQL_USER: wiki
      MYSQL_PASSWORD: WikiP@ssw0rd
      MYSQL_RANDOM_ROOT_PASSWORD: 'yes'
    volumes:
      - db:/var/lib/mysql

volumes:
  images:
  db:
EOF
docker compose -f wiki.yml up -d
cat <<EOF > /tmp/ym.txt
После настройки на hq -cli ввести это чтобы применить групповые политики
admx-msi-setup
echo "Что нужно заскринить: 1)hostname;
2) IP ADDRESS;
3) Созданного пользователя (cat /etc/passwd);
4) Изменненый порт в фалйе (/etc/openssh/sshd_config);
5) Сервер chrony (chronyc sources);
6) Домен созданный (samba-tool domain info 127.0.0.1);
7) Созданная группа (samba-tool group listmembers hq);
8) Файл ансибла (cat /etc/ansible/hosts);
9) Проверка ансибла (ansible -m ping all);
10) Медиа вики запущенный (docker ps);
Затем удаляем 
rm -rf /tmp/ym.txt
set -o history" 
EOF
