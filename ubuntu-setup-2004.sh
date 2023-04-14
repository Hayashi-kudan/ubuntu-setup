#!/usr/bin/env bash

echo "Install Google Chrome"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt update
sudo apt install -y google-chrome-stable

echo "Install basic tools"
sudo apt update
sudo apt install -y \
    wget \
    curl \
    make \
    cmake \
    build-essential \
    git \
    terminator \
    vim

# echo "Install nvidia cuda"
sudo apt install linux-headers-$(uname -r)
cd ~/Downloads
wget https://developer.download.nvidia.com/compute/cuda/repos/$distro/$arch/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
cd ..
# sudo apt update
# sudo apt install cuda
# sudo apt install nvidia-gds

sudo apt install -y gnome-tweak-tool hwinfo

sudo apt install software-properties-common apt-transport-https wget -y
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install -y code
