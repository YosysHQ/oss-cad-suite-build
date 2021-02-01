cd yices
autoconf
./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME}
if [ ${ARCH_BASE} == 'linux' ]; then
	sed -i 's,make.include.\$(ARCH),make.include.${CROSS_NAME},g' Makefile
fi
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} install
