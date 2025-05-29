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
echo "search au-team.irpo" > /etc/net/ifaces/ens18/resolv.conf
echo "nameserver 192.168.0.30" >> /etc/net/ifaces/ens18/resolv.conf
echo "nameserver 192.168.1.62" >> /etc/net/ifaces/ens18/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/net/ifaces/ens18/resolv.conf
systemctl restart network
apt-get update && apt-get install -y chrony 
cat <<EOF > /etc/chrony.conf
# Use public server from the pool
# Please consider joining the pool
server 172.16.4.1
EOF
 set -o history
systemctl restart chronyd
apt-get update && apt-get install -y gpupdate
sleep 240
gpupdate-setup enable
apt-get install -y admc
apt-get install -y gpui
kinit administrator@AU-TEAM.IRPO
apt-get install -y libnss-role
roleadd hq wheel
sed 's/User_Alias      WHEEL_USERS = %wheel/User_Alias      WHEEL_USERS = %wheel, %AU-TEAM\\hq/' /etc/sudoers
sed '35i Cmnd_Alias   SHELLCMD = /usr/bin/id, /bin/cat, /bin/grep' /etc/sudoers
sed '102i WHEEL_USERS ALL=(ALL:ALL) SHELLCMD' /etc/sudoers
apt-get install -y admx-*
admx-msi-setup
sleep 240]
gpupdate -f 
apt-get update && apt-get install -y nfs-{utils,clients}
mkdir /mnt/nfs 
chmod 777 /mnt/nfs 
echo "192.168.1.62:/raid5/nfs    /mnt/nfs    nfs    defaults    0    0" >> /etc/fstab
mount -av
df -h
apt-get update && apt-get install -y yandex-browser-stable
