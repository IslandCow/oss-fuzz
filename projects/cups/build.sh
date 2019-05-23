#!/bin/bash

./configure --enable-static --disable-gnutls --disable-shared --enable-sanitizer --disable-libusb --with-components=libcupslite
make clean
make install-libs

$CXX $CXXFLAGS -std=c++11 -I. \
    $SRC/fuzz/cups_ppdopen_fuzzer.cc -o $OUT/cups_ppdopen_fuzzer \
    $LIB_FUZZING_ENGINE /usr/lib/libcups.a
