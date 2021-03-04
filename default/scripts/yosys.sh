cd yosys
if [ ${ARCH} == 'linux-x64' ] || [ ${ARCH} == 'darwin-x64' ]; then
	make config-clang
elif [ ${ARCH} == 'windows-x64' ]; then
	echo 'CONFIG := msys2-64' > Makefile.conf
	echo 'ENABLE_PLUGINS := 0' >> Makefile.conf
else
	make config-gcc
	sed -i -re "s,CXX = gcc,CXX = ${CC},g" Makefile
	sed -i -re "s,LD = gcc,LD = ${CC},g" Makefile
fi
make PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} install -j${NPROC}
pushd ${OUTPUT_DIR}${INSTALL_PREFIX} 
mkdir -p lib
if [ ${ARCH} != 'windows-x64' ]; then
	ln -s ../bin/yosys-abc lib/
fi
popd
