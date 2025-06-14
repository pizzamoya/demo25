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
apt-get install -y tzdata
timedatectl set-timezone Europe/Samara
set -o history
systemctl restart network
useradd -u 1010 -m -s /bin/bash sshuser
echo -e "P@ssw0rd\nP@ssw0rd" | passwd sshuser
usermod -aG wheel sshuser
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
AllowUsers user
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
apt-get update && apt-get install -y chrony 
cat <<EOF > /etc/chrony.conf
# Use public server from the pool
# Please consider joining the pool
server 172.16.4.1
EOF
 set -o history
systemctl restart chronyd
apt-get update && apt-get install -y gpupdate
gpupdate-setup enable
apt-get install -y admc
apt-get install -y gpui
apt-get install -y libnss-role
roleadd hq wheel
sed 's/User_Alias      WHEEL_USERS = %wheel/User_Alias      WHEEL_USERS = %wheel, %AU-TEAM\\hq/' /etc/sudoers
sed '35i Cmnd_Alias   SHELLCMD = /usr/bin/id, /bin/cat, /bin/grep' /etc/sudoers
sed '102i WHEEL_USERS ALL=(ALL:ALL) SHELLCMD' /etc/sudoers
apt-get install -y admx-*
echo "он спит"
sleep 5
admx-msi-setup
apt-get update && apt-get install -y nfs-{utils,clients}
mkdir /mnt/nfs 
chmod 777 /mnt/nfs 
echo "192.168.1.62:/raid5/nfs    /mnt/nfs    nfs    defaults    0    0" >> /etc/fstab
mount -av
df -h
apt-get update && apt-get install -y yandex-browser-stable
set +o history
touch /mnt/nfs/Proverka
cat <<EOF > /etc/resolv.conf
search au-team.irpo
nameserver 192.168.0.30
EOF
 set +o history
cat <<EOF > /tmp/test1.txt
Это после настройки медиавики чтобы скинуть php на br-srv
scp -P 2024 /home/user/Downloads/LocalSettings.php sshuser@192.168.0.30:/home/sshuser/
br-srv# cp /home/sshuser/LocalSettings.php /root/docker
EOF
cat /tmp/test1.txt
set -o history
cat <<EOF > /tmp/ym.txt
ПОМЕНЯЙТЕ В RESOLV.CONF 
первый nameserver 192.168.0.30
"Что нужно заскринить:
1)hostname;
2)ip addres (dhcp);
3) Настроенную сеть и айпишники;
4) домен
5) Сервер chrony (chronyc sources);
6) moodle вместе с их url
7) mediawiki вместе с их url
Затем удаляем 
rm -rf /tmp/help.txt
gpupdate -f НЕ ЗАБЫТЬ 
EOF
