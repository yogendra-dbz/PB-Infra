#!/bin/bash

ssh-keygen -f ~/.ssh/known_hosts -R 35.168.203.14
ssh-keygen -f ~/.ssh/known_hosts -R 35.172.249.241
ssh-keygen -f ~/.ssh/known_hosts -R 18.233.41.155

ssh-keyscan -H  35.168.203.14 >>  ~/.ssh/known_hosts
ssh-keyscan -H 35.172.249.241 >>  ~/.ssh/known_hosts
ssh-keyscan -H 18.233.41.155 >>  ~/.ssh/known_hosts

echo "$PBPASS" > `pwd`/my_password.txt