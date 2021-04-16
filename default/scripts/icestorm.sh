cd icestorm
make PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} install -j${NPROC}
if [ ${ARCH_BASE} != 'windows' ]; then
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec
    mv ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/icebox.py ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec/.
    mv ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/iceboxdb.py ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec/.
fi
