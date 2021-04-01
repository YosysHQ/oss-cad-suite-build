pushd nextpnr/ice40
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DICEBOX_DATADIR=${BUILD_DIR}/icestorm${INSTALL_PREFIX}/share/icebox \
      .
make
mkdir -p ${OUTPUT_DIR}/ice40/chipdb
cp chipdb/* ${OUTPUT_DIR}/ice40/chipdb/.
popd