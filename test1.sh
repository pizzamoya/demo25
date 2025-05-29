#!/bin/bash
history -c 
apt-get update
apt-get install nano -y 
set +o history
> ~/.bash_history
set -o history
