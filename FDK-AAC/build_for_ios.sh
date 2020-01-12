#!/bin/bash

LIB_PATH="$(pwd)/thin/apple"

function build_for_ios
{
echo "compile for ios $CPU"
./configure \
--enable-static \
--disable-shared \
--with-pic=yes \
--host="$HOST" \
--prefix="$LIB_PATH/$CPU" \
CC="$CC" \
CXX="$CXX" \
CPP="$CPP" \
AS="$AS" \
CFLAGS="$CFLAGS" \
CPPFLAGS="$CPPFLAGS" \
LDFLAGS="$LDFLAGS"

make clean
make -j4
make install

echo "complete compiling for ios $CPU"
}

#armv7

CPU=armv7
HOST="arm-apple-darwin"
CC="xcrun -sdk iphoneos clang"
CXX="$CC"
CPP="$CC -E"
AS="gas-preprocessor.pl $CC"
CFLAGS="-arch $CPU -fembed-bitcode"
LDFLAGS="$CFLAGS"
CPPFLAGS="$CFLAGS"
build_for_ios

#arm64
CPU=arm64
HOST="aarch64-apple-darwin"
CC="xcrun -sdk iphoneos clang"
CXX="$CC"
CPP="$CC -E"
AS="gas-preprocessor.pl $CC"
CFLAGS="-arch $CPU -fembed-bitcode"
LDFLAGS="$CFLAGS"
CPPFLAGS="$CFLAGS"
build_for_ios

FAT_LIB_PATH="$LIB_PATH/fatLibs"
rm -r $FAT_LIB_PATH
mkdir $FAT_LIB_PATH
for LIB in `ls $LIB_PATH/$CPU/lib | grep \\.a`
do
    echo "merge $LIB..."
    lipo -create `find $LIB_PATH -name $LIB` -output $FAT_LIB_PATH/$LIB
done
