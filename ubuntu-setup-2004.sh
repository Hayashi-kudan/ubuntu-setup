#!/usr/bin/env bash

echo "Install Google Chrome"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt update
sudo apt install -y google-chrome-stable

echo "Install basic tools"
sudo apt update
sudo apt install -y \
    make \
    cmake \
    build-essential \
    git \
    terminator \
    vim
