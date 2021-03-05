cd nextpnr
export LD_LIBRARY_PATH=${BUILD_DIR}/python3${INSTALL_PREFIX}/lib
build_gui="ON"
if [ ${ARCH} == 'linux-arm' ]; then
      build_gui="OFF"
fi
if [ ${LOCAL_PYTHON} != 'True' ]; then
      python_var="-DPYTHON_EXECUTABLE=${BUILD_DIR}/python3${INSTALL_PREFIX}/py3bin/python3.8
                  -DPYTHON_INCLUDE_DIR=${BUILD_DIR}/python3${INSTALL_PREFIX}/include/python3.8
                  -DPYTHON_LIBRARY=${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/libpython3.8${SHARED_EXT}"
fi
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      ${python_var} \
      -DARCH=ecp5 -DTRELLIS_LIBDIR=${BUILD_DIR}/prjtrellis${INSTALL_PREFIX}/lib/trellis \
      -DTRELLIS_DATADIR=${BUILD_DIR}/prjtrellis${INSTALL_PREFIX}/share/trellis \
      -DBUILD_GUI=${build_gui} .
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
