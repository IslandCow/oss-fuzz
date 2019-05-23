#!/bin/bash

./configure --enable-static --disable-shared --enable-sanitizer --disable-libusb --with-components=libcupslite
make clean
make install-libs
