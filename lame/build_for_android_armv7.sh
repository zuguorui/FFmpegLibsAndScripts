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

./configure --host=arm-linux-android \
--disable-shared \
--disable-frontend \
--enable-static \
--prefix=`pwd`/"thin/android/armv7" \
CPPFLAGS="-fPIC"

make clean
make -j8
make install
