#!/bin/bash -eu
# Copyright 2016 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

# Build CUPS
pushd cups
# Fix bad line
sed -i '2110s/f->value/(int)f->value/' cups/ppd-cache.c

./configure --enable-static --disable-gnutls --disable-shared \
   --disable-libusb --with-components=core

make clean
make install-headers install-libs
popd

cd ghostpdl
rm -r cups/libs || die
rm -r freetype || die
rm -r libpng || die
rm -r tiff || die
rm -r zlib || die

autoconf
./configure --enable-freetype --enable-fontconfig \
  --enable-cups --with-ijs --with-jbig2dec \
  --with-drivers=cups,ljet4,laserjet,pxlmono,pxlcolor,pcl3,uniprint
make -j4 libgs

$CXX $CXXFLAGS -std=c++11 -I. \
    fuzz/gstoraster_fuzzer.cc \
    -o $OUT/gstoraster_fuzzer \
    /usr/lib/libcups.a \
    /usr/lib/libcupsimage.a \
    /usr/lib/x86_64-linux-gnu/libz.a \
    /usr/lib/x86_64-linux-gnu/libpthread.a \
    $LIB_FUZZING_ENGINE bin/gs.a
