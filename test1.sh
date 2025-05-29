#!/bin/bash
apt-get update
apt-get install nano -y 
set +o history
> ~/.bash_history
history -d 2 
set -o history
