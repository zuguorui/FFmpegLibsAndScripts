#!/bin/bash

NDK_ROOT=/Users/zu/AndroidSDK/ndk/20.0.5594570

HOST_TAG=darwin-x86_64

export TOOLCHAIN=$NDK_ROOT/toolchains/llvm/prebuilt/$HOST_TAG

export AR=$TOOLCHAIN/bin/arm-linux-androideabi-ar
export AS=$TOOLCHAIN/bin/arm-linux-androideabi-as
export CC=$TOOLCHAIN/bin/armv7a-linux-androideabi21-clang
export CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi21-clang++
export LD=$TOOLCHAIN/bin/arm-linux-androideabi-ld
export RANLIB=$TOOLCHAIN/bin/arm-linux-androideabi-ranlib
export STRIP=$TOOLCHAIN/bin/arm-linux-androideabi-strip


./configure --host=arm-linux \
--disable-shared \
--disable-cli \
--disable-asm \
--extra-cflags="-march=armv7-a -O2 -mfloat-abi=softfp -mfpu=neon -fPIC" \
--enable-static \
--prefix=`pwd`/"thin/android/armv7"
# --sysroot="$NDK_ROOT/platforms/android-21/arch-arm"

make clean
make -j8
make install