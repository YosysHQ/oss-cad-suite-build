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
			# Remove link to non-existing file
			rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libpython3.8.dll.a
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
fi
export _PYTHON_PROJECT_BASE=${BUILD_DIR}/python3 
export PYTHONPATH=${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8:${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages
pip_cmd="pip install flask --target ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages --no-cache-dir --disable-pip-version-check"
if [ ${ARCH} == 'linux-arm' ]; then
	_PYTHON_HOST_PLATFORM=linux-arm  _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_arm-linux-gnueabihf python3.8 -m ${pip_cmd}
elif [ ${ARCH} == 'linux-arm64' ]; then
	_PYTHON_HOST_PLATFORM=linux-aarch64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_aarch64-linux-gnu python3.8 -m ${pip_cmd}
elif [ ${ARCH} == 'linux-riscv64' ]; then
	_PYTHON_HOST_PLATFORM=linux-riscv64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_riscv64-linux-gnu python3.8 -m ${pip_cmd}
elif [ ${ARCH} == 'linux-x64' ]; then
	_PYTHON_HOST_PLATFORM=linux-x64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_x86_64-linux-gnu python3.8 -m ${pip_cmd}
elif [ ${ARCH} == 'darwin-x64' ]; then
	DYLD_LIBRARY_PATH=${BUILD_DIR}/python3 ./python.exe -m ${pip_cmd}
fi
