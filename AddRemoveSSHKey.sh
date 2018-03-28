#!/bin/bash

ssh-keygen -f ~/.ssh/known_hosts -R 50.17.161.139
ssh-keygen -f ~/.ssh/known_hosts -R 34.236.181.148
ssh-keygen -f ~/.ssh/known_hosts -R 34.228.33.92

ssh-keyscan -H  50.17.161.139 >>  ~/.ssh/known_hosts
ssh-keyscan -H 34.236.181.148 >>  ~/.ssh/known_hosts
ssh-keyscan -H 34.228.33.92 >>  ~/.ssh/known_hosts
