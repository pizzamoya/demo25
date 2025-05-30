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
sed 's/#Port 22/Port 2024/' /etc/openssh/sshd_config
sed '26i AllowUsers sshuser' /etc/openssh/sshd_config
sed 's/#MaxAuthTries 6/MaxAuthTries 2/' /etc/openssh/sshd_config
sed '105i Banner /etc/openssh/banner' /etc/openssh/sshd_config
echo "Authorized access only" > /etc/openssh/banner
 set +o history
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

#PubkeyAuthentication yes
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
#PasswordAuthentication yes
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
systemctl disable --now bind
apt-get update
apt-get install -y dnsmasq
apt-get install -y chrony
 set +o history
cat <<EOF > /etc/dnsmasq.conf
no-resolv
no-poll
no-hosts
listen-address=192.168.1.62
server=77.88.8.8
server=8.8.8.8
cache-size=1000
all-servers
no-negcache
host-record=hq-rtr.au-team.irpo,192.168.1.1
host-record=hq-srv.au-team.irpo,192.168.1.62
host-record=hq-cli.au-team.irpo,192.168.1.66
address=/br-rtr.au-team.irpo/192.168.0.1
address=/br-srv.au-team.irpo/192.168.0.30
cname=moodle.au-team.irpo,hq-rtr.au-team.irpo
cname=wiki.au-team.irpo,hq-rtr.au-team.irpo
EOF
cat <<EOF > /etc/chrony.conf
# Use public server from the pool
# Please consider joining the pool
server 172.16.4.1
EOF
 set -o history
systemctl restart dnsmasq
systemctl restart chronyd
apt-get update && apt-get install -y mdadm
mdadm --create --verbose /dev/md0 -l 5 -n 3 /dev/sd{b,c,d}
mdadm --detail --scan --verbose | tee -a /etc/mdadm.conf
mkfs.ext4 /dev/md0
echo "/dev/md0        /raid5  ext4    defaults        0       0" >> /etc/fstab
mkdir /raid5
mount -av
apt-get install -y nfs-{server,utils}
mkdir /raid5/nfs
chmod 777 /raid5/nfs
echo "/raid5/nfs 192.168.1.64/28(rw,no_root_squash)" >> /etc/exports
exportfs -arv
systemctl enable --now nfs-server

apt-get install -y moodle moodle-apache2
apt-get install -y mariadb-server php8.2-mysqlnd-mysqli
systemctl enable --now mariadb
cat <<EOF > /tmp/modle.txt
CREATE DATABASE moodledb;
CREATE USER 'moodle'@'%' IDENTIFIED BY 'P@ssw0rd';
GRANT ALL PRIVILEGES ON moodledb.* TO 'moodle'@'%' WITH GRANT OPTION;
EOF
cat /tmp/modle.txt
mariadb -u root
systemctl enable --now httpd2
 set +o history
 cat <<EOF > /tmp/ym.txt
"Что нужно заскринить:
1)hostname;
2) Ip address;
3) Созданного пользователя;
4) Измененный порт 2024 (/etc/openssh/sshd_config);
5) Созданный raid массив(df -h);
6) Отформатированный раздел ext4 (cat /etc/fstab);
7)Созданный dns сервер (пингануть все машины по доменному имени);
8) Подключение к chony(chronyc sources);
9) Созданную базу данных ( зайти в бд (mariadb -u root, SHOW DATABASES);
Затем удаляем 
rm -rf /tmp/help.txt
set -o history" 
EOF 
