pushd prjtrellis/libtrellis
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -DBUILD_PYTHON=ON \
      .
make -j${NPROC} pytrellis
popd
cd nextpnr
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DTRELLIS_LIBDIR=${BUILD_DIR}/prjtrellis/libtrellis \
      -DTRELLIS_DATADIR=${BUILD_DIR}/prjtrellis \
      -DARCH="ecp5;machxo2" \
      -DEXPORT_BBA_FILES=${OUTPUT_DIR}/bba-files \
      -B build
make -C build nextpnr-all-bba
