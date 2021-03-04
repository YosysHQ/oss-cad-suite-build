cd yices
autoconf
./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME}
if [ ${ARCH_BASE} == 'linux' ]; then
	sed -i 's,make.include.\$(ARCH),make.include.${CROSS_NAME},g' Makefile
fi
if [ ${ARCH_BASE} == 'windows' ]; then
	mv configs/make.include.x86_64-w64-mingw32 configs/make.include.x86_64-pc-mingw64
fi
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} install
