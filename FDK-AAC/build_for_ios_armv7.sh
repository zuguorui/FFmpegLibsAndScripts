#!/bin/bash

CC="xcrun -sdk iphoneos clang"
CXX="$CC"
CPP="$CC -E"
AS="gas-preprocessor.pl $CC"
CFLAGS="-arch armv7 -fembed-bitcode"
LDFLAGS="$CFLAGS"
CPPFLAGS="$CFLAGS"

./configure \
--enable-static \
--disable-shared \
--with-pic=yes \
--host=arm-apple-darwin \
--prefix=`pwd`/"thin/apple/armv7" \
CC="$CC" \
CXX="$CXX" \
CPP="$CPP" \
AS="$AS" \
CFLAGS="$CFLAGS" \
CPPFLAGS="$CPPFLAGS" \
LDFLAGS="$LDFLAGS"

echo configure_flags: $CONFIGURE_FLAGS
echo host: $HOST
echo cpu: $CPU
echo CC: $CC
echo CXX: $CXX
echo CPP: $CPP
echo AS: $AS
echo LD: $LDFLAGS
echo CFLAGS: $CFLAGS
echo CPPFLAGS: $CPPFLAGS

make clean
make -j4
make install