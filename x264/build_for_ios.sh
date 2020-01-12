#!/bin/bash

LIB_PATH="$(pwd)/thin/apple"

export CC="xcrun -sdk iphoneos clang"


function build_for_ios
{
echo "compile for ios $CPU"
./configure \
--enable-static \
--enable-pic \
--disable-shared \
--host="$HOST" \
--extra-cflags="$C_FLAGS" \
--extra-asflags="$AS_FLAGS" \
--extra-ldflags="$LD_FLAGS" \
--prefix="$LIB_PATH/$CPU"
make clean
make -j8
make install

echo "complete compiling for ios $CPU"
}

#armv7
CPU=armv7
ARCH=arm
HOST="arm-apple-darwin"
export AS="gas-preprocessor.pl -arch $ARCH -- $CC"
C_FLAGS="-arch $CPU -mios-version-min=7.0 -fembed-bitcode"
LD_FLAGS="$C_FLAGS"
AS_FLAGS="$C_FLAGS"
build_for_ios

#arm64
CPU=arm64
ARCH=arm64
HOST="aarch64-apple-darwin"
export AS="gas-preprocessor.pl -arch $ARCH -- $CC"
C_FLAGS="-arch $CPU -mios-version-min=7.0 -fembed-bitcode"
LD_FLAGS="$C_FLAGS"
AS_FLAGS="$C_FLAGS"
build_for_ios

#merge
FAT_LIBS="$LIB_PATH/fatLibs"
rm -r $FAT_LIBS
mkdir $FAT_LIBS
for LIB in `ls $LIB_PATH/$CPU/lib | grep \\.a`
do
    echo "merge $LIB..."
    lipo -create `find $LIB_PATH -name $LIB` -output $FAT_LIBS/$LIB
done

