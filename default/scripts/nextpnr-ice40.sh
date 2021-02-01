cd nextpnr
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -DPYTHON_INCLUDE_DIR=${BUILD_DIR}/python3${INSTALL_PREFIX}/include/python3.8 \
      -DPYTHON_LIBRARY=${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/libpython3.8${SHARED_EXT} \
      -DARCH=ice40 -DICEBOX_DATADIR=${BUILD_DIR}/icestorm${INSTALL_PREFIX}/share/icebox \
      -DBUILD_GUI=ON .
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
