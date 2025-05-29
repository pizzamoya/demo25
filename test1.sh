#!/bin/bash
set -o history
apt-get install nano -y 
> ~/.bash_history
history -d 2 
set -o history
