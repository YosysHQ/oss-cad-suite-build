cd python3
patch -p1 < ${PATCHES_DIR}/python38.diff
if [ ${ARCH} == 'darwin-x64' ]; then
	patch -p1 < ${PATCHES_DIR}/python38-darwin.diff
	sed -e "s|MACOS = (HOST_PLATFORM == 'darwin')|MACOS = (HOST_PLATFORM.startswith('darwin'))|g" -i setup.py 
	autoreconf -vfi
    export CFLAGS="-I/opt/local/include"
    export LDFLAGS="-L/opt/local/lib"
    echo "ac_cv_file__dev_ptmx=no" > config.site
    echo "ac_cv_file__dev_ptc=no" >> config.site
    CONFIG_SITE=config.site ./configure --prefix=${INSTALL_PREFIX} --enable-optimizations --enable-shared --with-system-ffi --with-openssl=/opt/local --host=${CROSS_NAME} --build=`gcc -dumpmachine`  --disable-ipv6
elif [ ${ARCH} == 'windows-x64' ]; then
	patch -p1 < ${PATCHES_DIR}/python38-mingw.diff
	autoreconf -vfi
    export CFLAGS=" -fwrapv -D__USE_MINGW_ANSI_STDIO=1 -D_WIN32_WINNT=0x0601"
    export CXXFLAGS=" -fwrapv -D__USE_MINGW_ANSI_STDIO=1 -D_WIN32_WINNT=0x0601"
	./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME} --build=`gcc -dumpmachine`  \
		--enable-optimizations \
		--enable-shared \
		--with-nt-threads \
		--with-computed-gotos \
		--with-system-expat \
		--with-system-ffi \
		--without-c-locale-coercion \
		--enable-loadable-sqlite-extensions
    sed -e "s|windres|x86_64-w64-mingw32-windres|g" -i Makefile
	sed -e "s|#define HAVE_DECL_RTLD_LOCAL 1|#define HAVE_DECL_RTLD_LOCAL 0|g" -i pyconfig.h
	sed -e "s|#define HAVE_DECL_RTLD_GLOBAL 1|#define HAVE_DECL_RTLD_GLOBAL 0|g" -i pyconfig.h	
else
    echo "ac_cv_file__dev_ptmx=no" > config.site
    echo "ac_cv_file__dev_ptc=no" >> config.site
    CONFIG_SITE=config.site ./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME} --build=`gcc -dumpmachine` --disable-ipv6 --enable-optimizations --enable-shared --with-system-ffi --with-ensurepip=install
fi

make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
if [ -d "${OUTPUT_DIR}/usr" ]; then
    cp -r ${OUTPUT_DIR}/usr/* ${OUTPUT_DIR}${INSTALL_PREFIX}/.
    rm -rf ${OUTPUT_DIR}/usr
fi
mv ${OUTPUT_DIR}${INSTALL_PREFIX}/bin ${OUTPUT_DIR}${INSTALL_PREFIX}/py3bin
if [ ${ARCH_BASE} == 'darwin' ]; then
    install_name_tool -id ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libpython3.8.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libpython3.8.dylib
    install_name_tool -change ${INSTALL_PREFIX}/lib/libpython3.8.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libpython3.8.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/py3bin/python3.8
elif [ ${ARCH} == 'windows-x64' ]; then
	cp ${OUTPUT_DIR}${INSTALL_PREFIX}/py3bin/libpython3.8.dll ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
	cp ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/_sysconfigdata__win_.py ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/_sysconfigdata__win32_.py
fi
find ${OUTPUT_DIR}${INSTALL_PREFIX} -name "libpython*.a" | xargs rm -rf
