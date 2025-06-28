cd nextpnr
cmake -DXilinxChipdb_Python3_EXECUTABLE=${BUILD_DIR}/python3-native${INSTALL_PREFIX}/bin/python3.11 \
      -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DARCH=himbaechel -DHIMBAECHEL_UARCH=xilinx \
      -DHIMBAECHEL_XILINX_DEVICES=all \
      -DHIMBAECHEL_PRJXRAY_DB=${BUILD_DIR}/prjxray-db \
      -DEXPORT_BBA_FILES=${OUTPUT_DIR}/bba-files \
      -B build

make -C build nextpnr-all-bba
