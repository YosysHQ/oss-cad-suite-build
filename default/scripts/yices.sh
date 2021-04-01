cd yices
autoconf
./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME}
if [ ${ARCH_BASE} == 'linux' ]; then
	sed -i 's,make.include.\$(ARCH),make.include.${CROSS_NAME},g' Makefile
fi
if [ ${ARCH_BASE} == 'windows' ]; then
	sed -i 's,make.include.\$(ARCH),make.include.x86_64-w64-mingw32,g' Makefile
	sed -i 's,ARCH=\$(shell ./config.sub `./config.guess`),ARCH=x86_64-pc-mingw64,g' Makefile
	sed -i 's,POSIXOS=\$(shell ./autoconf/os),POSIXOS=mingw,g' Makefile
fi
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} install
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/include
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
