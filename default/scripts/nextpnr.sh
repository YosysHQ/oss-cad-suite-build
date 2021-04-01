cd nextpnr
export LD_LIBRARY_PATH=${BUILD_DIR}/prjtrellis-py
build_gui="ON"
if [ ${ARCH} == 'linux-arm' ]; then
      build_gui="OFF"
fi
if [ ${ARCH} == 'windows-x64' ]; then
      sed -i 's,CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE,CMAKE_INTERPROCEDURAL_OPTIMIZATION FALSE,g' CMakeLists.txt
fi
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DPYTHON_INCLUDE_DIR=${BUILD_DIR}/python3${INSTALL_PREFIX}/include/python3.8 \
      -DPYTHON_LIBRARY=${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/libpython3.8${SHARED_EXT} \
      -DARCH="generic;ice40;ecp5;machxo2;nexus" \
      -DICE40_CHIPDB=${BUILD_DIR}/icestorm-bba/ice40/chipdb \
      -DECP5_CHIPDB=${BUILD_DIR}/prjtrellis-bba/ecp5/chipdb \
      -DMACHXO2_CHIPDB=${BUILD_DIR}/prjtrellis-bba/machxo2/chipdb \
      -DNEXUS_CHIPDB=${BUILD_DIR}/prjoxide-bba/nexus/chipdb \
      -DBUILD_GUI=${build_gui} . -DBBA_IMPORT=${BUILD_DIR}/nextpnr-bba/nextpnr/bba/bba-export.cmake
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
