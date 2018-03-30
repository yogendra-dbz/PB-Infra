#!/bin/bash

sudo ssh-keygen -f ~/.ssh/known_hosts -R 35.168.203.14
sudo ssh-keygen -f ~/.ssh/known_hosts -R 35.172.249.241
sudo ssh-keygen -f ~/.ssh/known_hosts -R 18.233.41.155

sudo ssh-keyscan -H  35.168.203.14 >>  ~/.ssh/known_hosts
sudo ssh-keyscan -H 35.172.249.241 >>  ~/.ssh/known_hosts
sudo ssh-keyscan -H 18.233.41.155 >>  ~/.ssh/known_hosts

sudo echo "$PBPASS" > `pwd`/my_password.txt
