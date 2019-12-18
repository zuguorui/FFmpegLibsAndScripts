#!/bin/sh
export CC="xcrun -sdk iphoneos clang"
export AS="gas-preprocessor.pl -arch arm -- $CC"
ARCH="armv7"
C_FLAGS="-arch $ARCH -mios-version-min=7.0 -fembed-bitcode"
LD_FLAGS="$C_FLAGS"
AS_FLAGS="$C_FLAGS"
./configure \
--enable-static \
--enable-pic \
--disable-shared \
--host=arm-apple-darwin \
--extra-cflags="$C_FLAGS" \
--extra-asflags="$AS_FLAGS" \
--extra-ldflags="$LD_FLAGS" \
--prefix=`pwd`/"thin/apple/armv7"
make clean
make -j8
make install