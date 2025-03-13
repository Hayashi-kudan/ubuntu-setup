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
    ethtool \
    net-tools \
    hwinfo \
    inxi \
    cutecom \
    snapd \
    cpufrequtils \
    intel-gpu-tools

sudo apt install python-is-python3 -y

sudo apt install -y gnome-shell=3.36.4-1ubuntu1~20.04.2 gnome-shell-common=3.36.4-1ubuntu1~20.04.2 gnome-shell-extension-prefs=3.36.4-1ubuntu1~20.04.2
sudo apt install -y gnome-tweak-tool

echo "Install kazam, meld"
sudo add-apt-repository -y ppa:sylvain-pineau/kazam
sudo apt install -y kazam
sudo apt install -y meld python3-nautilus
sudo add-apt-repository -y ppa:boamaod/nautilus-compare
sudo apt install -y nautilus-compare
nautilus -q

echo "Install VS code"
sudo apt install software-properties-common apt-transport-https wget -y
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install -y code

echo "Install foxglove"
sudo snap install foxglove-studio

echo "Install flatpak"
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Add XDG_DATA_DIRS update for flatpak
echo 'export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:/home/$USER/.local/share/flatpak/exports/share"' >> ~/.bashrc
source ~/.bashrc

# Use -y flag with flatpak install
flatpak install -y flathub org.cloudcompare.CloudCompare

echo "Install ROS Noetic"
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt install curl # if you haven't already installed curl
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
curl -sSL https://packages.osrfoundation.org/gazebo.key | gpg --dearmor | sudo tee /usr/share/keyrings/gazebo-keyring.gpg > /dev/null
sudo apt update

sudo apt install aptitude -y

# Fix dependency issues by installing required packages first
sudo aptitude install -y python-is-python3 python3-pip
sudo aptitude install -y libboost-all-dev libopencv-dev libpcl-dev
sudo aptitude install -y libsdl-image1.2-dev libsdl1.2-dev

# Now install ROS packages
sudo aptitude install -y ros-noetic-desktop-full

# Install ROS packages individually to handle dependency issues
sudo aptitude install -y ros-noetic-ddynamic-reconfigure
sudo aptitude install -y ros-noetic-rosbag
sudo aptitude install -y ros-noetic-pcl-ros
sudo aptitude install -y ros-noetic-rviz
sudo aptitude install -y ros-noetic-cv-bridge
sudo aptitude install -y ros-noetic-tf2-geometry-msgs
sudo aptitude install -y ros-noetic-eigen-conversions
sudo aptitude install -y ros-noetic-tf-conversions
sudo aptitude install -y ros-noetic-xacro
sudo aptitude install -y ros-noetic-robot-state-publisher

sudo aptitude install -y ros-noetic-rosserial
sudo aptitude install -y ros-noetic-slam-gmapping
sudo aptitude install -y ros-noetic-map-server
sudo aptitude install -y ros-noetic-navigation

echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc

sudo aptitude install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential

# Initialize rosdep if not already initialized
if [ ! -d "/etc/ros/rosdep" ]; then
  sudo rosdep init || echo "rosdep init failed, may already be initialized"
fi
rosdep update || echo "rosdep update failed"

echo "Install Third-party libraries"
sudo aptitude install -y libpdal-dev liburdfdom-tools setserial

# Fix htop installation - remove -y flag from snap command
sudo snap install htop

sudo add-apt-repository ppa:appimagelauncher-team/stable -y
sudo apt update
sudo aptitude install appimagelauncher -y
sudo apt install -y simplescreenrecorder
