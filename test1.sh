#!/bin/bash
history -c 
set +o history
usermod -aG wheel root
chmod +x test1.sh
apt-get remove -y git
cd .. 
rm -rf demo25
set -o history
apt-get update
apt-get install nano -y 

set +o history
mate-terminal --window -e "bash -c 'sudo systemctl status network; read -p \"Нажмите Enter для выхода...\"'"
set -o history

