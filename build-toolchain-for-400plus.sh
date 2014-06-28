#!/bin/bash
#BUILD TOOLCHAIN FOR UBUNTU 
#Test with 13.10 (32bit) & 14.04(64bit)
#patch for gengtype.c https://gcc.gnu.org/bugzilla/show_bug.cgi?id=51969
#patch for ira-int.h  http://www.spinics.net/lists/gcchelp/msg41530.html

mkdir /opt/build
mkdir /opt/apps

#GET OLD TEXINFO, ELSE BUILD FAILS
cd /opt/build
wget http://ftp.gnu.org/gnu/texinfo/texinfo-4.13.tar.gz
tar -xvzf texinfo-4.13.tar.gz
cd texinfo-4.13
./configure --prefix=/opt/apps/texinfo-4.13
export PATH=/opt/apps/texinfo-4.13/bin:$PATH
cd ..

#BUILD TOOLCHAIN
hg clone https://bitbucket.org/hudson/magic-lantern
cd magic-lantern
hg update unified
cd contrib/toolchain
cd patches
wget https://raw.githubusercontent.com/draekko/arm-462-toolchain-400plus/master/patch-gcc-4.6.2-gengtype.diff
wget https://raw.githubusercontent.com/draekko/arm-462-toolchain-400plus/master/patch-gcc-4.6.2-ira-int.diff
cd ..
mv summon-arm summon-arm.orig
wget https://raw.githubusercontent.com/draekko/arm-462-toolchain-400plus/master/summon-arm
chmod 777 prepare.ubuntu.sh summon-arm
./prepare.ubuntu.sh
./summon-arm
cd /opt/build

#COMPILE 400PLUS CODE
export PATH=/opt/apps/arm-toolchain-462/bin:$PATH
svn checkout http://400plus.googlecode.com/svn/trunk/ 400plus-read-only
cd 400plus-read-only
make

