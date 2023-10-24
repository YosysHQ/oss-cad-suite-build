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
CONFIG_SITE=config.site ./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME} --build=`gcc -dumpmachine` --disable-ipv6 --with-system-ffi --with-ensurepip=install
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
if [ -d "${OUTPUT_DIR}/usr" ]; then
    cp -r ${OUTPUT_DIR}/usr/* ${OUTPUT_DIR}${INSTALL_PREFIX}/.
    rm -rf ${OUTPUT_DIR}/usr
fi

mkdir -p ${OUTPUT_DIR}/dev
mv ${OUTPUT_DIR}${INSTALL_PREFIX}/include ${OUTPUT_DIR}/dev/.
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/pkgconfig
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python2.7/config/libpython2.7.a