cd nextpnr
sed -i 's,'3.25','3.22',g' CMakeLists.txt
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DOXIDE_INSTALL_PREFIX=${BUILD_DIR}/prjoxide${INSTALL_PREFIX} \
      -DARCH=nexus .
make chipdb-nexus-bbas
mkdir -p ${OUTPUT_DIR}/nexus/chipdb
cp nexus/chipdb/* ${OUTPUT_DIR}/nexus/chipdb/.
