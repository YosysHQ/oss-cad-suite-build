cd nextpnr
build_gui="ON"
if [ ${ARCH} == 'linux-arm' ]; then
      build_gui="OFF"
fi
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -DPYTHON_INCLUDE_DIR=${BUILD_DIR}/python3${INSTALL_PREFIX}/include/python3.8 \
      -DPYTHON_LIBRARY=${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/libpython3.8${SHARED_EXT} \
      -DARCH=generic -DBUILD_GUI=${build_gui} .
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
