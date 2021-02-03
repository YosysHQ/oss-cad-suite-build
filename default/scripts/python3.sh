cd python3
patch -p1 < ${PATCHES_DIR}/python38.diff
if [ ${ARCH} == 'darwin-x64' ]; then
    export CFLAGS="-I$(brew --prefix zlib)/include -I$(brew --prefix libffi)/include -I$(brew --prefix readline)/include -I$(brew --prefix openssl)/include -I$(xcrun --show-sdk-path)/usr/include"
    export LDFLAGS="-L$(brew --prefix zlib)/lib -L$(brew --prefix libffi)/lib -L$(brew --prefix readline)/lib -L$(brew --prefix openssl)/lib"
    ./configure --prefix=${INSTALL_PREFIX} --enable-optimizations --enable-shared --with-system-ffi --with-openssl=$(brew --prefix openssl)
else
    ./configure --prefix=${INSTALL_PREFIX} --enable-optimizations --enable-shared --with-system-ffi
fi

make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
mv ${OUTPUT_DIR}${INSTALL_PREFIX}/bin ${OUTPUT_DIR}${INSTALL_PREFIX}/py3bin
if [ ${ARCH_BASE} == 'darwin' ]; then
    install_name_tool -id ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libpython3.8.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libpython3.8.dylib
    install_name_tool -change ${INSTALL_PREFIX}/lib/libpython3.8.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libpython3.8.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/py3bin/python3.8
fi
