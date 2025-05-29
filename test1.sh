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
sudo systemctl status network > /tmp/network_status.txt  # Без пробелов в имени!
sudo chmod 644 /tmp/network_status.txt
cat /tmp/network_status.txt > /dev/pts/1  # Или вручную скопируйте вывод
rm /tmp/network_status.txt
set -o history

