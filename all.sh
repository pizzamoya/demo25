#!/bin/bash
if [ "$HOSTNAME" = HQ-SRV.au-team.irpo ]; then
useradd sshuser -u 1010
echo -e "P@ssw0rd\nP@ssw0rd" | passwd sshuser
usermod -aG wheel sshuser
cat <<EOF >> /etc/sudoers
sshuser ALL=(ALL) NOPASSWD:ALL
EOF
sed -i 's/#Port 22/Port 2024/' /etc/openssh/sshd_config
sed -i 's/#MaxAuthTries 6/MaxAuthTries 2/' /etc/openssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/openssh/sshd_config
cat <<EOF >> /etc/openssh/sshd_config 
AllowUsers sshuser
EOF
cat << EOF >> /etc/openssh/bannermotd
----------------------
Authorized access only
----------------------
EOF
systemctl restart sshd
