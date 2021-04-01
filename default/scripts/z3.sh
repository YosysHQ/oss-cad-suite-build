cd z3
if [ ${ARCH_BASE} == 'windows' ]; then
	sed -i 's,IS_LINUX=True,IS_MSYS2=True,g' scripts/mk_util.py
	sed -i 's/sysname, _, _, _, machine = os.uname()/sysname,machine=[ "MINGW64", "x86_64"]/g' scripts/mk_util.py
fi
python3 scripts/mk_make.py
cd build
if [ ${ARCH} == 'linux-riscv64' ]; then
	sed -i -re 's,-lpthread,-lpthread -latomic,g' config.mk
fi
make PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} -j${NPROC}
make PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} -j${NPROC} install
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/include
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
