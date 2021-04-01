pushd prjtrellis/libtrellis
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -DBUILD_PYTHON=ON \
      .
make -j${NPROC} pytrellis
popd
pushd nextpnr/ecp5
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DTRELLIS_LIBDIR=${BUILD_DIR}/prjtrellis/libtrellis \
      -DTRELLIS_DATADIR=${BUILD_DIR}/prjtrellis \
      .
make
mkdir -p ${OUTPUT_DIR}/ecp5/chipdb
cp chipdb/* ${OUTPUT_DIR}/ecp5/chipdb/.
popd
pushd nextpnr/machxo2
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DTRELLIS_LIBDIR=${BUILD_DIR}/prjtrellis/libtrellis \
      -DTRELLIS_DATADIR=${BUILD_DIR}/prjtrellis \
      .
make
mkdir -p ${OUTPUT_DIR}/machxo2/chipdb
cp chipdb/* ${OUTPUT_DIR}/machxo2/chipdb/.
popd
