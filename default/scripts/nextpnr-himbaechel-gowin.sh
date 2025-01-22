cd nextpnr
cp -R ${BUILD_DIR}/apicula${INSTALL_PREFIX}/lib/python3.11/site-packages/*  ${BUILD_DIR}/python3-native${INSTALL_PREFIX}/lib/python3.11/site-packages/.
cp ${BUILD_DIR}/python3-native${INSTALL_PREFIX}/bin/python3.11 ${BUILD_DIR}/python3-native${INSTALL_PREFIX}/bin/python
cmake -DPython3_EXECUTABLE=${BUILD_DIR}/python3-native${INSTALL_PREFIX}/bin/python3.11 \
      -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DARCH=himbaechel \
      -DHIMBAECHEL_GOWIN_DEVICES=all \
      .
make DESTDIR=${OUTPUT_DIR} -j${NPROC} chipdb-himbaechel-gowin

mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/share/nextpnr/himbaechel/gowin
mv share/himbaechel/gowin/*.bin ${OUTPUT_DIR}${INSTALL_PREFIX}/share/nextpnr/himbaechel/gowin/.
