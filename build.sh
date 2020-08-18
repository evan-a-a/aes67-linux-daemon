#!/bin/bash
#
# Tested on Ubuntu 18.04
#

#we need clang when compiling on ARMv7
export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

cd 3rdparty
if [ ! -d ravenna-alsa-lkm ]; then
  echo "Apply patches to ravenna-alsa-lkm module ..."
  git apply ../patches/ravenna-alsa-lkm-kernel-v5.patch
  git apply ../patches/ravenna-alsa-lkm-enable-loopback.patch
  git apply ../patches/ravenna-alsa-lkm-fixes.patch
  git apply ../patches/ravenna-alsa-lkm-arm-32bit.patch
  git apply ../patches/ravenna-alsa-lkm-add-codec-am824.patch
  git apply ../patches/ravenna-alsa-lkm-disable-ptp-checksum.patch
  git apply ../patches/ravenna-alsa-lkm-independent-playback-capture.patch
  git apply ../patches/ravenna-alsa-lkm-direct-pcm-transfer.patch
  echo "Building ravenna-alsa-lkm kernel module ..."
  cd driver
  make
  cd ../..
fi
cd ..

cd webui
echo "Building and installing webui ..."
npm install
npm run build
cd ..

cd daemon
echo "Building aes67-daemon ..."
cmake -DWITH_AVAHI=ON .
make
cd ..

