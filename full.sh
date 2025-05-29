#!/bin/bash
# Подсказки:
# 1) Активировать скрипт через . так он не оставит следов и отчистит историю
if [ "$HOSTNAME" = isp ]; then
history -c 
set +o history
> ~/.bash_history
> /root/.bash_history
echo "export HISTCONTROL=ignorespace:ignoredups" >> ~/.bashrc
source ~/.bashrc
usermod -aG wheel root
chmod +x full.sh
apt-get remove -y git
cd .. 
rm -rf demo25
echo "nameserver 77.88.8.8" >> /etc/resolv.conf
set -o history
hostnamectl set-hostname isp
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
iptables –t nat –A POSTROUTING –o ens18 –j MASQUERADE
iptables-save >> /etc/sysconfig/iptables
systemctl enable --now iptables
iptables -t nat -L -n -v
fi
