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
apt-get update
apt-get install nano -y 
 set +o history
mate-terminal --window -- bash -c "systemctl status network" &
mate-terminal --window -- bash -c "systemctl status sshd" &
set -o history

