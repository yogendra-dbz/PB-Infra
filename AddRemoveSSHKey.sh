#!/bin/bash

sudo ssh-keygen -f ~/.ssh/known_hosts -R 18.208.27.151
sudo ssh-keygen -f ~/.ssh/known_hosts -R 18.234.17.242
sudo ssh-keygen -f ~/.ssh/known_hosts -R 35.174.145.65
sudo ssh-keygen -f ~/.ssh/known_hosts -R 35.174.79.128

sudo ssh-keyscan -H  18.208.27.151 >>  ~/.ssh/known_hosts
sudo ssh-keyscan -H 18.234.17.242 >>  ~/.ssh/known_hosts
sudo ssh-keyscan -H 35.174.145.65 >>  ~/.ssh/known_hosts
sudo ssh-keyscan -H 35.174.79.128 >>  ~/.ssh/known_hosts

sudo echo "$PBPASS" > `pwd`/my_password.txt
