#!/usr/bin/env bash

echo "Install Google Chrome"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt update
sudo apt install -y google-chrome-stable
sudo rm /etc/apt/sources.list.d/google.list

echo "Install basic tools"
sudo apt update
sudo apt install -y \
    wget \
    curl \
    make \
    cmake \
    build-essential \
    git \
    jq \
    terminator \
    vim
sudo apt install -y hwinfo inxi cutecom snapd
sudo apt install -y intel-gpu-tools

sudo apt install -y gnome-shell=3.36.4-1ubuntu1~20.04.2 gnome-shell-common=3.36.4-1ubuntu1~20.04.2 gnome-shell-extension-prefs=3.36.4-1ubuntu1~20.04.2
sudo apt install -y gnome-tweak-tool

echo "Install kdiff3, meld"
sudo apt install -y kdiff3 meld
sudo apt install -y python3-nautilus
sudo add-apt-repository ppa:boamaod/nautilus-compare
sudo apt install -y nautilus-compare
nautilus -q

echo "Install kazam"
sudo add-apt-repository ppa:sylvain-pineau/kazam
sudo apt install kazam
# sudo vim $HOME/.config/kazam/kazam.conf
# autosave_picture_dir = /home/username/Pictures
# rm -r ~/.config/pulse
# sudo pulseaudio -k
# pulseaudio --start


echo "Install nvidia cuda"
sudo apt install linux-headers-$(uname -r)
cd ~/Downloads
distro=$(. /etc/os-release;echo $ID$VERSION_ID | sed -e 's/\.//g')
arch=$(/usr/bin/uname -m)
wget https://developer.download.nvidia.com/compute/cuda/repos/$distro/$arch/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
cd -
# sudo apt update
# sudo apt install -y nvidia-driver-525
# sudo apt install -y cuda-toolkit-12-0

# sudo vim /lib/modprobe.d/nvidia-kms.conf
# options nvidia-drm modeset=0

# sudo vim /etc/default/grub
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash pci=realloc"

# https://forums.developer.nvidia.com/t/linux-mint-nvidia-driver-loads-with-startx-but-not-on-initial-startup/168262
# sudo vim /etc/initramfs-tools/modules
# # Add the below lines
# nvidia
# nvidia-modeset
# nvidia-drm

# sudo update-initramfs -u
# sudo update-grub

# echo 'export PATH="/usr/local/cuda/bin:$PATH"' >> ~/.bashrc
# echo 'export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"' >> ~/.bashrc

sudo apt install software-properties-common apt-transport-https wget -y
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install -y code

echo "Install tools"
sudo snap install cloudcompare
sudo snap install foxglove-studio

echo "Install ROS Noetic"
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo apt update
sudo apt install -y ros-noetic-desktop-full
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
sudo apt install -y \
    ros-noetic-rosbag \
    ros-noetic-pcl-ros \
    ros-noetic-rviz \
    ros-noetic-cv-bridge \
    ros-noetic-tf2-geometry-msgs \
    ros-noetic-eigen-conversions \
    ros-noetic-tf-conversions \
    ros-noetic-xacro \
    ros-noetic-robot-state-publisher

sudo apt install -y python3-venv
sudo apt install -y setserial