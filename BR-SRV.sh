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
useradd sshuser -u 1010 -m -s /bin/bash sshuser
echo -e "P@ssw0rd\nP@ssw0rd" | passwd sshuser
usermod -aG wheel sshuser
echo "sshuser ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
cat <<EOF > /etc/openssh/sshd_config
sed "s/#Port 22/Port 2024/' /etc/openssh/sshd_config
sed '26i AllowUsers sshuser' /etc/openssh/sshd_config
sed 's/#MaxAuthTries 6/MaxAuthTries 2/' /etc/openssh/sshd_config
sed '105i Banner /etc/openssh/banner /etc/openssh/sshd_config
echo "Authorized access only" > /etc/openssh/banner
systemctl restart sshd
apt-get install -y chrony
 set +o history
 cat <<EOF > /etc/chrony.conf
# Use public server from the pool
# Please consider joining the pool
server 172.16.5.1
EOF
 set -o history
