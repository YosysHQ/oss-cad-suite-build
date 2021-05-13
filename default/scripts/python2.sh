cd python2
patch -p1 < ${PATCHES_DIR}/python27.diff
if [ ${ARCH} == 'darwin-x64' ]; then
    export CFLAGS="-I/opt/local/include"
    export LDFLAGS="-L/opt/local/lib"
	patch -p1 < ${PATCHES_DIR}/python27-darwin.diff
	autoreconf -vfi
fi
echo "ac_cv_file__dev_ptmx=no" > config.site
echo "ac_cv_file__dev_ptc=no" >> config.site
CONFIG_SITE=config.site ./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME} --build=`gcc -dumpmachine` --disable-ipv6 --enable-shared --with-system-ffi --with-ensurepip=install
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
if [ -d "${OUTPUT_DIR}/usr" ]; then
    cp -r ${OUTPUT_DIR}/usr/* ${OUTPUT_DIR}${INSTALL_PREFIX}/.
    rm -rf ${OUTPUT_DIR}/usr
fi
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/bin

export _PYTHON_PROJECT_BASE=${BUILD_DIR}/python2
export PYTHONPATH=${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python2.7:${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python2.7/plat-linux2:${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python2.7/site-packages
pip_cmd="pip install future --target ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python2.7/site-packages --no-cache-dir --disable-pip-version-check"
if [ ${ARCH} == 'linux-arm' ]; then
	_PYTHON_HOST_PLATFORM=linux2-arm  python2.7 -m ${pip_cmd}
elif [ ${ARCH} == 'linux-arm64' ]; then
	_PYTHON_HOST_PLATFORM=linux2-aarch64 python2.7 -m ${pip_cmd}
elif [ ${ARCH} == 'linux-riscv64' ]; then
	_PYTHON_HOST_PLATFORM=linux2-riscv64 python2.7 -m ${pip_cmd}
elif [ ${ARCH} == 'linux-x64' ]; then
	_PYTHON_HOST_PLATFORM=linux2-x64 python2.7 -m ${pip_cmd}
elif [ ${ARCH} == 'darwin-x64' ]; then
	_PYTHON_HOST_PLATFORM=darwin-x64 python2.7 -m ${pip_cmd}
fi

mkdir -p ${OUTPUT_DIR}/dev
mv ${OUTPUT_DIR}${INSTALL_PREFIX}/include ${OUTPUT_DIR}/dev/.
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/pkgconfig
