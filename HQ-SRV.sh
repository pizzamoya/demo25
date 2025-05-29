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
sed 's/#Port 22/Port 2024/' /etc/openssh/sshd_config
sed '26i AllowUsers sshuser' /etc/openssh/sshd_config
sed 's/#MaxAuthTries 6/MaxAuthTries 2/' /etc/openssh/sshd_config
sed '105i Banner /etc/openssh/banner' /etc/openssh/sshd_config
echo "Authorized access only" > /etc/openssh/banner
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
lsblk
mdadm --zero-superblock --force /dev/sd{b,c,d}
wipefs --all --force /dev/sd{b,c,d}
mdadm --create /dev/md0 -l 5 -n 3 /dev/sd{b,c,d}
mkfs -t ext4 /dev/md0
mkdir /etc/mdadm
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
mkdir /mnt/raid5 -y ,
cat <<EOF >> /etc/fstab
/dev/md0 /mnt/raid5 ext4 defaults 0 0 
EOF
mount -a 
apt-get update && apt-get install -y nfs-{server,utils}
mkdir /mnt/raid5/nfs
cat <<EOF >> /etc/exports
/mnt/raid5/nfs 192.168.1.64/28 -rw,no_root_squash
exportfs -arv
systemctl enable --now nfs-server
apt-get install -y moodle moodle-apache2
apt-get install -y mariadb-server php8.2-mysqlnd-mysqli
systemctl enable --now mariadb
mariadb -u root -е "CREATE DATABASE moodledb;"
mariadb -u root -e "CREATE USER 'moodle'@'%' IDENTIFIED BY 'P@ssw0rd';"
mariadb -u root -e "GRANT ALL PRIVILEGES ON moodledb.* TO 'moodle'@'%' WITH GRANT OPTION;"
sed -i "s/; max_input_vars = 1000/max_input_vars = 5000/g" /etc/php/8.2/apache2-mod_php/php.ini
systemctl enable --now httpd2
