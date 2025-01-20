cd nextpnr
sed -i 's,'3.25','3.22',g' CMakeLists.txt
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DICEBOX_DATADIR=${BUILD_DIR}/icestorm${INSTALL_PREFIX}/share/icebox \
      -DARCH=ice40 .
make chipdb-ice40-bbas
mkdir -p ${OUTPUT_DIR}/ice40/chipdb
cp ice40/chipdb/* ${OUTPUT_DIR}/ice40/chipdb/.
