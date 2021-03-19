if [ ${LOCAL_PYTHON} == 'True' ]; then
	mkdir -p python3
	cd python3
	curl -L https://raw.githubusercontent.com/python/cpython/master/LICENSE > LICENSE
	if [ ${ARCH} == 'windows-x64' ]; then
		if [ ${IS_NATIVE} == 'True' ]; then
			for f in $(pacman -Ql mingw-w64-x86_64-python mingw-w64-x86_64-python-pip mingw-w64-x86_64-python-setuptools | cut -f2 -d' '); do
				if [ -d "$f" ]; then
					mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/$f
				elif [ -f "$f" ]; then
					cp $f ${OUTPUT_DIR}${INSTALL_PREFIX}/$f
				fi
			done
			mv ${OUTPUT_DIR}${INSTALL_PREFIX}/mingw64/* ${OUTPUT_DIR}${INSTALL_PREFIX}/.
			rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/mingw64
			mv ${OUTPUT_DIR}${INSTALL_PREFIX}/bin ${OUTPUT_DIR}${INSTALL_PREFIX}/py3bin
		else
			for f in $(dnf repoquery --installed -l mingw64-python3 | grep /usr/x86_64-w64-mingw32/sys-root/mingw); do
				if [ -d "$f" ]; then
					mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}$f
				elif [ -f "$f" ]; then
					mkdir -p `dirname ${OUTPUT_DIR}${INSTALL_PREFIX}$f`
					cp -r $f ${OUTPUT_DIR}${INSTALL_PREFIX}$f
				fi
			done
			mv ${OUTPUT_DIR}${INSTALL_PREFIX}/usr/x86_64-w64-mingw32/sys-root/mingw/* ${OUTPUT_DIR}${INSTALL_PREFIX}/.
			rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/usr
			mv ${OUTPUT_DIR}${INSTALL_PREFIX}/bin ${OUTPUT_DIR}${INSTALL_PREFIX}/py3bin
		fi		
	fi
    exit
fi
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
