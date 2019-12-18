#!/bin/bash

# To link extern lib, you may need to try for some times to find out how FFmpeg located it. For example, if you 
# want to enable fdk-aac, you should put header files in a folder named "fdk-aac", and pass a c flag as "-IparentFolder",
# the "parentFolder" containes the "fdk-aac" folder, so the FFmpeg can find the header files correctly. But for lame and x264,
# you can put header files wherever you want. If some errors occured during compiling, please see "ffbuild/config.log" for
# details.

# WARNING: Please be sure all configure options are available, or the compile will not success. FFmpeg won't ignore wrong or unknown
# options. And don't put comment in a whole line sentence, it can break the sentence and the following configure options will be ignored.
NDK=/Users/zu/AndroidSDK/ndk/20.0.5594570
HOST_TAG=darwin-x86_64
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG

ANDROID_LIB_PATH="$(pwd)/thin/android"

API=29

function build_android_arm
{
echo "Compiling FFmpeg for $CPU"
./configure \
--disable-stripping \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-avdevice \
--disable-devices \
--disable-indevs \
--disable-outdevs \
--disable-debug \
--disable-x86asm \
--disable-doc \
--enable-gpl \
--enable-nonfree \
--enable-version3 \
--enable-static \
--enable-small \
--enable-dct \
--enable-dwt \
--enable-lsp \
--enable-mdct \
--enable-rdft \
--enable-fft \
--disable-filters \
--disable-postproc \
--disable-bsfs \
--enable-bsf=h264_mp4toannexb \
--enable-bsf=aac_adtstoasc \
--disable-encoders \
--enable-encoder=pcm_s16le \
--enable-encoder=aac \
--enable-encoder=libvo_aacenc \
--disable-decoders \
--enable-decoder=aac \
--enable-decoder=mp3 \
--enable-decoder=pcm_s16le \
--disable-parsers \
--enable-parser=aac \
--disable-muxers \
--enable-muxer=flv \
--enable-muxer=wav \
--enable-muxer=adts \
--disable-demuxers \
--enable-demuxer=flv \
--enable-demuxer=wav \
--enable-demuxer=aac \
--disable-protocols \
--enable-protocol=rtmp \
--enable-protocol=file \
--enable-libx264 \
--enable-libfdk-aac \
--disable-iconv \
--prefix="$PREFIX" \
--cross-prefix="$CROSS_PREFIX" \
--target-os=android \
--arch="$ARCH" \
--cpu="$CPU" \
--cc="$CC" \
--cxx="$CXX" \
--enable-cross-compile \
--sysroot="$SYSROOT" \
--extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS" \
--extra-ldflags="-Lexternal-lib/lame/android/$CPU/ -Lexternal-lib/fdk-aac/android/$CPU/ -Lexternal-lib/x264/android/$CPU/"
make clean
make -j8
make install
echo "The Compilation of FFmpeg for $CPU is completed"
}

#armv8-a
ARCH=arm64
CPU=armv8-a
CC=$TOOLCHAIN/bin/aarch64-linux-android$API-clang
CXX=$TOOLCHAIN/bin/aarch64-linux-android$API-clang++
SYSROOT=$NDK/toolchains/llvm/prebuilt/$HOST_TAG/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
PREFIX=$ANDROID_LIB_PATH/$CPU
OPTIMIZE_CFLAGS="-march=$CPU -Iexternal-lib/lame/include -Iexternal-lib/fdk-aac/include -Iexternal-lib/x264/include"
build_android_arm

#armv7-a
ARCH=arm
CPU=armv7-a
CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang
CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang++
SYSROOT=$NDK/toolchains/llvm/prebuilt/$HOST_TAG/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
PREFIX=$ANDROID_LIB_PATH/$CPU
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU -Iexternal-lib/lame/include -Iexternal-lib/fdk-aac/include -Iexternal-lib/x264/include"
build_android_arm




