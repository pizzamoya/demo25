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
mate-terminal --window &
sudo -u $(who | awk '$2 ~ /pts\/1/ {print $1}') systemctl status network
set -o history

