#!/bin/bash

NDK_ROOT=/Users/zu/AndroidSDK/ndk/20.0.5594570

HOST_TAG=darwin-x86_64

export TOOLCHAIN=$NDK_ROOT/toolchains/llvm/prebuilt/$HOST_TAG

export AR=$TOOLCHAIN/bin/aarch64-linux-android-ar
export AS=$TOOLCHAIN/bin/aarch64-linux-android-as
export CC=$TOOLCHAIN/bin/aarch64-linux-android21-clang
export CXX=$TOOLCHAIN/bin/aarch64-linux-android21-clang++
export LD=$TOOLCHAIN/bin/aarch64-linux-android-ld
export RANLIB=$TOOLCHAIN/bin/aarch64-linux-android-ranlib
export STRIP=$TOOLCHAIN/bin/aarch64-linux-android-strip


./configure --host=arm-linux \
--disable-shared \
--disable-cli \
--disable-asm \
--extra-cflags="-O2 -mfloat-abi=softfp -mfpu=neon -fPIC" \
--enable-static \
--prefix=`pwd`/"thin/android/arm64"
# --sysroot="$NDK_ROOT/platforms/android-21/arch-arm"

make clean
make -j8
make install