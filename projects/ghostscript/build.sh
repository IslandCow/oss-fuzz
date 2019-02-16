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
rm -r cups/libs || die
rm -r freetype || die
rm -r libpng || die
rm -r tiff || die
rm -r zlib || die

autoconf
./configure --enable-dynamic --enable-freetype --enable-fontconfig \
  --enable-cups --with-ijs --with-jbig2dec \
  --with-drivers=cups,ljet4,laserjet,pxlmono,plxcolor,pcl3,uniprint
make

pushd ijs
./configure --enable-shared
make
popd

make install

pushd ijs
make install
popd

cd ../chromiumos-overlay/chromeos-base/ghostscript-fuzz/files/
make
cp *_fuzzer $OUT/
