cd yosys
if [ ${ARCH} == 'linux-x64' ] || [ ${ARCH} == 'darwin-x64' ]; then
	make config-clang
else
	make config-gcc
	sed -i -re "s,CXX = gcc,CXX = ${CC},g" Makefile
	sed -i -re "s,LD = gcc,LD = ${CC},g" Makefile
fi
make PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} install -j${NPROC}
pushd ${OUTPUT_DIR}${INSTALL_PREFIX} 
mkdir -p lib
ln -s ../bin/yosys-abc lib/
popd
