./configure \
--disable-shared \
--disable-frontend \
--host=aarch64-apple-darwin \
--prefix=`pwd`/"thin/apple/arm64" \
CC="xcrun -sdk iphoneos clang -arch arm64" \
CFLAGS="-arch arm64 -fembed-bitcode -miphoneos-version-min=7.0" \
LDFLAGS="-arch arm64 -fembed-bitcode -miphoneos-version-min=7.0"
make clean
make -j4
make install