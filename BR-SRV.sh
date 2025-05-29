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
systemctl restart chronyd
cat <<EOF >> /etc/resolv.conf
nameserver 192.168.1.62
nameserver 8.8.8.8
EOF
apt-get update && apt-get install -y task-samba-dc
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
admx-msi-setup
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
#!/bin/bash
apt-get install -y docker-{engine,compose-v2}
systemctl enable --now docker.service
cat <<EOF > wiki.yml
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
