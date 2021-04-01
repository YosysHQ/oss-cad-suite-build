pushd nextpnr/nexus
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DOXIDE_INSTALL_PREFIX=${BUILD_DIR}/prjoxide${INSTALL_PREFIX} \
      .
make
mkdir -p ${OUTPUT_DIR}/nexus/chipdb
cp chipdb/* ${OUTPUT_DIR}/nexus/chipdb/.
popd