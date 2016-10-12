#!/bin/bash
#
# Copyright � 2015-2016, Akhil Narang "akhilnarang" <akhilnarang.1999@gmail.com>
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it
#

clear
echo Installing Dependencies!
sudo apt-add-repository ppa:openjdk-r/ppa -y
sudo apt-get update
sudo apt-get -y install git-core python gnupg flex bison gperf libsdl1.2-dev libesd0-dev libwxgtk2.8-dev \
squashfs-tools build-essential zip curl libncurses5-dev zlib1g-dev openjdk-8-jre openjdk-8-jdk pngcrush \
schedtool libxml2 libxml2-utils xsltproc lzop libc6-dev schedtool g++-multilib lib32z1-dev lib32ncurses5-dev \
gcc-multilib liblz4-* pngquant ncurses-dev texinfo gcc gperf patch libtool \
automake g++ gawk subversion expat libexpat1-dev python-all-dev binutils-static bc libcloog-isl-dev \
libcap-dev autoconf libgmp-dev build-essential gcc-multilib g++-multilib pkg-config libmpc-dev libmpfr-dev lzma* \
liblzma* w3m android-tools-adb maven ncftp figlet
echo Dependencies have been installed
echo repo has been Downloaded!
if [ ! "$(which adb)" == "" ];
then
echo Setting up USB Ports
sudo curl --create-dirs -L -o /etc/udev/rules.d/51-android.rules -O -L https://raw.githubusercontent.com/snowdream/51-android/master/51-android.rules
sudo chmod 644   /etc/udev/rules.d/51-android.rules
sudo chown root /etc/udev/rules.d/51-android.rules
sudo service udev restart
adb kill-server
sudo killall adb
fi

echo "Installing repo"
sudo install utils/repo /usr/bin/
echo "Installing ccache"
sudo install utils/ccache /usr/bin/

mkdir ~/bin
PATH=~/bin:$PATH
curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
git config --global user.email "androidwall.nrt@gmail.com"
git config --global user.name "saikrishna279"
cd /projects
mkdir tesla
cd tesla
repo init -u https://github.com/TeslaRom-N/manifest.git -b n7.0
repo sync -fcj16 --no-clone-bundle
mkdir kernel
cd device
mkdir motorola
cd motorola
git clone https://github.com/Megatron007/device_motorola_msm8960dt-common.git -b cm-14.0 msm8960dt-common
git clone https://github.com/saikrishna279/device_motorola_ghost.git -b Tesla-N ghost
cd ghost
rm main.mk
cd ../../../kernel
mkdir motorola
cd motorola
git clone https://github.com/Megatron007/kernel_motorola_ghost.git -b cm-14.0 ghost
cd ../../vendor
git clone git://github.com/TheMuppets/proprietary_vendor_motorola.git -b cm-13.0 motorola
cd ../build
rm -rf kati
git clone https://github.com/CyanogenMod/android_build_kati.git -b cm-14.0 kati
cd core
rm main.mk
wget https://raw.githubusercontent.com/saikrishna279/device_motorola_ghost/Tesla-N/main.mk
cd ../..
. build/envsetup.sh
brunch ghost

