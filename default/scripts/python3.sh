cd python3
if [ ${ARCH_BASE} == 'darwin' ]; then
	patch -p1 < ${PATCHES_DIR}/python3.11.6-darwin.diff
	sed -e "s|MACOS = (HOST_PLATFORM == 'darwin')|MACOS = (HOST_PLATFORM.startswith('darwin'))|g" -i setup.py 
	autoreconf -vfi
    export CFLAGS="-I/opt/local/include"
    export LDFLAGS="-L/opt/local/lib"
    echo "ac_cv_file__dev_ptmx=no" > config.site
    echo "ac_cv_file__dev_ptc=no" >> config.site
    CONFIG_SITE=config.site ./configure --prefix=${INSTALL_PREFIX} --enable-shared --with-system-ffi --with-openssl=/opt/local --host=${CROSS_NAME} --build=`gcc -dumpmachine`  --disable-ipv6  --with-build-python=${BUILD_DIR}/python3-native${INSTALL_PREFIX}/bin/python3.11
elif [ ${ARCH} == 'windows-x64' ]; then
	patch -p1 < ${PATCHES_DIR}/python3.11.6-mingw.diff
	autoreconf -vfi
	# Ensure that we are using the system copy of various libraries rather than copies shipped in the tarball
	rm -r Modules/expat
	rm -r Modules/_ctypes/{darwin,libffi}*
	# Just to be sure that we are using the wanted thread model
	rm -f Python/thread_nt.h
    echo "ac_cv_file__dev_ptmx=no" > config.site
    echo "ac_cv_file__dev_ptc=no" >> config.site
	export WINDRES=x86_64-w64-mingw32-windres
	CONFIG_SITE=config.site ./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME} --build=`gcc -dumpmachine`  \
		--enable-shared \
		--with-system-expat \
		--with-suffix=.exe \
		--enable-loadable-sqlite-extensions \
		--with-ensurepip=no \
		--with-build-python=${BUILD_DIR}/python3-native${INSTALL_PREFIX}/bin/python3.11
else
    echo "ac_cv_file__dev_ptmx=no" > config.site
    echo "ac_cv_file__dev_ptc=no" >> config.site
	CONFIG_SITE=config.site ./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME} --build=`gcc -dumpmachine` --disable-ipv6 --enable-shared --with-ensurepip=no --with-build-python=${BUILD_DIR}/python3-native${INSTALL_PREFIX}/bin/python3.11
fi

make DESTDIR=${OUTPUT_DIR} -j${NPROC} install

cp -R ${BUILD_DIR}/python3-native${INSTALL_PREFIX}/lib/python3.11/site-packages/*  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.11/site-packages/.
cp -R ${BUILD_DIR}/python3-native${INSTALL_PREFIX}/bin/pip*  ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.

mv ${OUTPUT_DIR}${INSTALL_PREFIX}/bin ${OUTPUT_DIR}${INSTALL_PREFIX}/py3bin
if [ ${ARCH_BASE} == 'darwin' ]; then
    install_name_tool -id ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libpython3.11.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libpython3.11.dylib
    install_name_tool -change ${INSTALL_PREFIX}/lib/libpython3.11.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libpython3.11.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/py3bin/python3.11
elif [ ${ARCH} == 'windows-x64' ]; then
	cp ${OUTPUT_DIR}${INSTALL_PREFIX}/py3bin/libpython3.11.dll ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
fi
find ${OUTPUT_DIR}${INSTALL_PREFIX} -name "libpython*.a" | xargs rm -rf
