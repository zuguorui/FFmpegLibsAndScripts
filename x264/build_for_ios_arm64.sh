#!/bin/sh
export CC="xcrun -sdk iphoneos clang"
export AS="gas-preprocessor.pl -arch arm64 -- $CC"
ARCH="arm64"
C_FLAGS="-arch $ARCH -mios-version-min=7.0 -fembed-bitcode"
LD_FLAGS="$C_FLAGS"
AS_FLAGS="$C_FLAGS"
./configure \
--enable-static \
--enable-pic \
--disable-shared \
--host=aarch64-apple-darwin \
--extra-cflags="$C_FLAGS" \
--extra-asflags="$AS_FLAGS" \
--extra-ldflags="$LD_FLAGS" \
--prefix=`pwd`/"thin/apple/arm64"
make clean
make -j8
make install