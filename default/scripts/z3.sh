cd z3
if [ ${ARCH_BASE} == 'windows' ]; then
	/usr/bin/python3 scripts/mk_make.py
else
	python scripts/mk_make.py
fi
cd build
make PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} -j${NPROC}
make PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} -j${NPROC} install
