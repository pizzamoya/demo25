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
mkdir /etc/net/ifaces/ens19
mkdir /etc/net/ifaces/ens20
echo "TYPE=eth" > /etc/net/ifaces/ens19/options
echo "BOOTPROTO=static" >> /etc/net/ifaces/ens19/options
cp /etc/net/ifaces/ens19/options /etc/net/ifaces/ens20/options
echo "172.16.4.1/28" > /etc/net/ifaces/ens19/ipv4address
echo "172.16.5.1/28" > /etc/net/ifaces/ens20/ipv4address
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/g' /etc/net/sysctl.conf
systemctl restart network
apt-get update && apt-get install -y iptables
iptables -A POSTROUTING -t nat -s 172.16.4.0/28 -o ens18 -j MASQUERADE
iptables -A POSTROUTING -t nat -s 172.16.5.0/28 -o ens18 -j MASQUERADE
iptables -t nat -L
iptables-save >> /etc/sysconfig/iptables
systemctl enable --now iptables
iptables -t nat -L -n -v
apt-get update && apt-get install -y nginx

cat >/etc/nginx/sites-available.d/proxy.conf <<'EOF'
server {
    listen 80;
    server_name moodle.au-team.irpo;
    location / {
        proxy_pass http://172.16.4.14/moodle/;
    }
}

server {
    listen 80;
    server_name wiki.au-team.irpo;
    location / {
        proxy_pass http://172.16.5.14;
    }
}
EOF
chmod 777 /etc/nginx/sites-available.d/proxy.conf
ln -s /etc/nginx/sites-available.d/proxy.conf /etc/nginx/sites-enabled.d/
nginx -t
systemctl enable --now nginx
systemctl reload nginx
apt-get install chrony -y
 set +o history
cat <<EOF > /etc/chrony.conf
# Use public servers from the pool
# Please consider joining the pool
#pool pool.ntp.org iburst
server 127.0.0.1 iburst
local stratum 5
allow 0.0.0.0/0
EOF
apt-get install -y tzdata
timedatectl set-timezone Europe/Samara
set -o history
systemctl restart chronyd
 set +o history
cat <<EOF > /tmp/ym.txt
"Что нужно заскринить: 1)hostname;
2) Включенный форвардинг(etc/net/sysctl.conf);
3) Настроенную сеть и айпишники;
4) Правила в iptables (# iptables -t nat -L -n -V);
5) Сервер chrony (chronyc clients);
6) Конфиг proxy (cat /etc/nginx/sites-available.d/proxy.conf);
Затем удаляем 
rm -rf /tmp/help.txt
set -o history" 
EOF

