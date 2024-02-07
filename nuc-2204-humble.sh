#!/usr/bin/env bash
sudo apt update && sudo apt upgrade -y

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
    ca-certificates \
    python3-pip \
    bash \
    git \
    unzip \
    xterm \
    build-essential \
    libeigen3-dev \
    libjsoncpp-dev \
    libspdlog-dev \
    jq \
    cmake \
    terminator \
    vim \
    gnome-tweaks \
    ethtool \
    net-tools \
    hwinfo \
    inxi \
    cutecom \
    snapd \
    intel-gpu-tools

echo "Install meld"
sudo apt install -y meld

echo "Install VS code"
sudo apt install software-properties-common apt-transport-https wget -y
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" -y
sudo apt update
sudo apt install -y code

echo "Install foxglove"
sudo snap install foxglove-studio

echo "Install flatpak"
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.cloudcompare.CloudCompare -y

echo "Install ROS2 Humble"
sudo apt install -y software-properties-common
sudo add-apt-repository universe -y
sudo apt update && sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo apt update && sudo apt upgrade -y
sudo apt install ros-humble-desktop -y
sudo apt install ros-dev-tools -y
sudo apt install -y ros-humble-pcl-*
sudo apt install -y ros-humble-gps-msgs
sudo apt install -y ros-humble-image-transport-plugins
sudo apt install -y build-essential python3-colcon-common-extensions python3-rosdep ros-humble-rmw-cyclonedds-cpp
sudo apt install -y ros-humble-turtlebot3*
sudo apt install -y ros-humble-rqt-tf-tree

echo "export RCUTILS_COLORIZED_OUTPUT=1" >> ~/.bashrc
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

echo "Install Third-party libraries"
sudo apt install -y libpdal-dev
sudo apt install -y python-is-python3
sudo apt install -y setserial
pip install pyserial
