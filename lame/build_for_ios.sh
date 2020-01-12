#!/bin/bash
LIB_PATH="$(pwd)/thin/apple"

function build_for_ios
{
echo "compile LAME for ios $CPU"
./configure \
--disable-shared \
--disable-frontend \
--host=aarch64-apple-darwin \
--prefix="$LIB_PATH/$CPU" \
CC="xcrun -sdk iphoneos clang -arch $CPU" \
CFLAGS="-arch $CPU -fembed-bitcode -miphoneos-version-min=7.0" \
LDFLAGS="-arch $CPU -fembed-bitcode -miphoneos-version-min=7.0"
make clean
make -j4
make install
echo "complete to compile for ios $CPU"
}

#armv7

CPU=armv7
build_for_ios

#arm64
CPU=arm64
build_for_ios

#merge
FAT_LIB_PATH="$LIB_PATH/fatLibs"

rm -r $FAT_LIB_PATH
mkdir $FAT_LIB_PATH

for LIB in `ls $LIB_PATH/$CPU/lib | grep \\.a`
do
    lipo -create `find $LIB_PATH -name $LIB` -output $FAT_LIB_PATH/$LIB
done
