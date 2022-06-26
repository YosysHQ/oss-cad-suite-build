cd ecpprog
cd ecpprog
if [ ${ARCH} == 'darwin-arm64' ]; then
make CC=${CXX} C_STD=c++98 PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} install -j${NPROC}
else
make C_STD=gnu99 PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} install -j${NPROC}
fi
