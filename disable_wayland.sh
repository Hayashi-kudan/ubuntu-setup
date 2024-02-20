#!/usr/bin/env bash

echo
echo "Setting to disable Wayland"

gdm3_custom_file="/etc/gdm3/custom.conf"
tmp_gdm3_custom="/tmp/$(basename ${gdm3_custom_file}).tmp"
sudo cp ${gdm3_custom_file} ${gdm3_custom_file}.ori
cp ${gdm3_custom_file} ${tmp_gdm3_custom}

sed -i 's/^#WaylandEnable=false/WaylandEnable=false/' ${tmp_gdm3_custom}

sudo cp ${tmp_gdm3_custom} ${gdm3_custom_file}
rm ${tmp_gdm3_custom}

sudo systemctl restart gdm
