#!/bin/bash
history -c 
set +o history
chmod +x test1.sh
apt-get remove -y git
cd .. 
rm -rf demo25
set -o history
apt-get update
apt-get install nano -y 
set +o history
mate-terminal --window &
sudo systemctl status network > /dev/pts/1
set -o history

