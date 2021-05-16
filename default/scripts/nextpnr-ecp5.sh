cd nextpnr
export LD_LIBRARY_PATH=${BUILD_DIR}/prjtrellis-py
build_gui="ON"
use_ipo="OFF"
if [ ${ARCH} == 'linux-arm' ]; then
      build_gui="OFF"
fi
if [ ${ARCH} == 'windows-x64' ]; then
      use_ipo="OFF"
fi
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DPYTHON_INCLUDE_DIR=${BUILD_DIR}/python3${INSTALL_PREFIX}/include/python3.8 \
      -DPYTHON_LIBRARY=${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/libpython3.8${SHARED_EXT} \
      -DARCH=ecp5 \
      -DECP5_CHIPDB=${BUILD_DIR}/prjtrellis-bba/ecp5/chipdb \
      -DBUILD_GUI=${build_gui} -DUSE_IPO=${use_ipo} . -DBBA_IMPORT=${BUILD_DIR}/nextpnr-bba/nextpnr/bba/bba-export.cmake
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
${STRIP} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/nextpnr-ecp5${EXE}
