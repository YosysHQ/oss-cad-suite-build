cd nextpnr
export LD_LIBRARY_PATH=${BUILD_DIR}/prjtrellis-py
build_gui="ON"
if [ ${ARCH} == 'linux-arm' ]; then
      build_gui="OFF"
fi
if [ ${LOCAL_PYTHON} != 'True' ]; then
      python_var="-DPYTHON_INCLUDE_DIR=${BUILD_DIR}/python3${INSTALL_PREFIX}/include/python3.8
                  -DPYTHON_LIBRARY=${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/libpython3.8${SHARED_EXT}"
fi
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      ${python_var} \
      -DARCH=ecp5 -DTRELLIS_LIBDIR=${BUILD_DIR}/prjtrellis-py \
      -DTRELLIS_DATADIR=${BUILD_DIR}/prjtrellis${INSTALL_PREFIX}/share/trellis \
      -DBUILD_GUI=${build_gui} . -DBBA_IMPORT=${BUILD_DIR}/nextpnr-bba/nextpnr/bba/bba-export.cmake
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
