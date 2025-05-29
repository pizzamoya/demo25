#!/bin/bash
history -c 
set +o history
apt-get remove -y git
set -o history
apt-get update
apt-get install nano -y 
set +o history
cd .. 
rm -rf demo25
set -o history
