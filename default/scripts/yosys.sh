cd yosys
if  [ ${ARCH_BASE} == 'darwin' ]; then
	make config-clang
	sed -i -re "s,CXX = clang,CXX = ${CC},g" Makefile
	sed -i -re "s,LD = clang\+\+,LD = ${CXX},g" Makefile
elif [ ${ARCH} == 'linux-x64' ]; then
	mkdir -p frontends/ghdl
	cp -R ../ghdl-yosys-plugin/src/* frontends/ghdl
	make config-clang
	echo 'ENABLE_GHDL := 1' > Makefile.conf
	echo "GHDL_PREFIX := $(pwd)/../ghdl${INSTALL_PREFIX}" >> Makefile.conf
elif [ ${ARCH} == 'windows-x64' ]; then
	echo 'CONFIG := msys2-64' > Makefile.conf
	echo 'ENABLE_PLUGINS := 0' >> Makefile.conf
	echo 'TCL_VERSION := tcl86' >> Makefile.conf
	sed 's|PYTHON := \$(shell cygpath -w -m \$(PREFIX)/bin/python3)|PYTHON := /usr/bin/python3|g' -i backends/smt2/Makefile.inc
else
	make config-gcc
	sed -i -re "s,CXX = gcc,CXX = ${CC},g" Makefile
	sed -i -re "s,LD = gcc,LD = ${CC},g" Makefile
fi
make PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} install -j${NPROC}
pushd ${OUTPUT_DIR}${INSTALL_PREFIX} 
if [ ${ARCH} != 'windows-x64' ]; then
	mkdir -p lib
	ln -s ../bin/yosys-abc lib/
fi
popd
