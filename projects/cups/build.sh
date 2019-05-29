#!/bin/bash

# Build CUPS
# Fix bad line
sed -i '2110s/f->value/(int)f->value/' cups/ppd-cache.c

./configure --enable-static --disable-gnutls --disable-shared \
   --disable-libusb --with-components=core

make clean
make install-libs

$CXX $CXXFLAGS -std=c++11 -I. \
    $SRC/fuzz/cups_ppdopen_fuzzer.cc -o $OUT/cups_ppdopen_fuzzer \
    $LIB_FUZZING_ENGINE /usr/lib/libcups.a
