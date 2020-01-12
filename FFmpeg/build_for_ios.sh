#!/bin/bash

IOS_LIB_PATH="$(pwd)/thin/apple"

function build_ios_arm
{
echo "Compiling FFmpeg for $ARCH"
./configure \
--disable-debug \
--disable-programs \
--disable-doc \
--enable-pic \
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
--enable-shared \
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
--disable-encoders \
--enable-encoder=pcm_s16le \
--disable-decoders \
--enable-decoder=mp3 \
--enable-decoder=pcm_s16le \
--disable-parsers \
--disable-muxers \
--enable-muxer=flv \
--enable-muxer=wav \
--enable-muxer=adts \
--disable-demuxers \
--enable-demuxer=flv \
--enable-demuxer=wav \
--disable-protocols \
--enable-protocol=rtmp \
--enable-protocol=file \
--enable-libx264 \
--enable-libfdk-aac \
--enable-static \
--disable-shared \
--target-os=darwin \
--arch="$ARCH" \
--cc="$CC" \
--as="$AS" \
--enable-cross-compile \
--extra-cflags="$CFLAGS -Iexternal-lib/lame/include -Iexternal-lib/fdk-aac/include -Iexternal-lib/x264/include" \
--extra-ldflags="$LDFLAGS -Lexternal-lib/lame/apple/ -Lexternal-lib/fdk-aac/apple/ -Lexternal-lib/x264/apple/" \
--prefix="$PREFIX"
make clean
make -j8
make install
echo "The Compilation of FFmpeg for $ARCH is completed"
}
#armv7
ARCH=armv7
PREFIX=$IOS_LIB_PATH/$ARCH
CC="xcrun -sdk iphoneos clang"
CXX="$CC"
CPP="$CC -E"
AS="gas-preprocessor.pl -- $CC"
CFLAGS="-arch $ARCH -fembed-bitcode -mios-version-min=8.0"
LDFLAGS="$CFLAGS"
echo "CC = $CC"
echo "arch = $ARCH"
echo "as = $AS"
echo "extra-cflags = $CFLAGS"
echo "extra-ldflags = $LDFLAGS"
build_ios_arm

#arm64
ARCH=arm64
PREFIX=$IOS_LIB_PATH/$ARCH
CC="xcrun -sdk iphoneos clang"
CXX="$CC"
CPP="$CC -E"
AS="gas-preprocessor.pl -arch arm64 -- $CC"
CFLAGS="-arch $ARCH -fembed-bitcode -mios-version-min=8.0"
LDFLAGS="$CFLAGS"
echo "CC = $CC"
echo "arch = $ARCH"
echo "as = $AS"
echo "extra-cflags = $CFLAGS"
echo "extra-ldflags = $LDFLAGS"
build_ios_arm

#lipo libs
ARMv7_PATH="$IOS_LIB_PATH/armv7"
ARM64_PATH="$IOS_LIB_PATH/arm64"
FAT_LIBS="$IOS_LIB_PATH/fatLibs"
rm -r $FAT_LIBS
mkdir $FAT_LIBS

for LIB in `ls $ARMv7_PATH/lib | grep \\.a`
do
    echo "merge $LIB..."
    lipo -create `find $IOS_LIB_PATH -name $LIB` -output $FAT_LIBS/$LIB
done
