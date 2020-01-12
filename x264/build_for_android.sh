#!/bin/bash

NDK=/Users/zu/AndroidSDK/ndk/20.0.5594570
HOST_TAG=darwin-x86_64
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
SYSROOT=$TOOLCHAIN/sysroot
ANDROID_LIB_PATH="$(pwd)/thin/android"


API=26

function build_android_arm
{
echo "build for android $CPU"
./configure \
--prefix="$ANDROID_LIB_PATH/$CPU" \
--host=$HOST \
--enable-shared \
--disable-static \
--disable-cli \
--disable-asm \
--extra-cflags="$CFLAGS" \
--prefix="$ANDROID_LIB_PATH/$CPU" \
--sysroot="$SYSROOT" \
--cross-prefix="$CROSS_PREFIX"

make clean
make -j8
make install
echo "building for android $CPU completed"
}

# armv7
CPU=armv7
HOST=arm-linux
CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
CFLAGS="-march=armv7-a -O2 -mfloat-abi=softfp -mfpu=neon -fPIC"
export CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang
export CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang++
build_android_arm

# armv8
CPU=armv8
HOST=arm-linux
CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
CFLAGS="-O2 -mfloat-abi=softfp -mfpu=neon -fPIC"
export CC=$TOOLCHAIN/bin/aarch64-linux-android$API-clang
export CXX=$TOOLCHAIN/bin/aarch64-linux-android$API-clang++
build_android_arm


