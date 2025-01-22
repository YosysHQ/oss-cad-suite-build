pushd prjtrellis/libtrellis
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -DBUILD_PYTHON=ON \
      .
make -j${NPROC} pytrellis
popd
pushd nextpnr
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DTRELLIS_LIBDIR=${BUILD_DIR}/prjtrellis/libtrellis \
      -DTRELLIS_DATADIR=${BUILD_DIR}/prjtrellis \
      -DARCH=ecp5 .
make chipdb-ecp5-bbas
mkdir -p ${OUTPUT_DIR}/ecp5/chipdb
cp ecp5/chipdb/* ${OUTPUT_DIR}/ecp5/chipdb/.
popd
pushd nextpnr
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DTRELLIS_LIBDIR=${BUILD_DIR}/prjtrellis/libtrellis \
      -DTRELLIS_DATADIR=${BUILD_DIR}/prjtrellis \
      -DARCH=machxo2 .
make chipdb-machxo2-bbas
mkdir -p ${OUTPUT_DIR}/machxo2/chipdb
cp machxo2/chipdb/* ${OUTPUT_DIR}/machxo2/chipdb/.
popd
