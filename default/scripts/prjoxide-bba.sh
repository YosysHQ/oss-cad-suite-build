cd nextpnr
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DOXIDE_INSTALL_PREFIX=${BUILD_DIR}/prjoxide${INSTALL_PREFIX} \
      -DARCH=nexus \
      -DEXPORT_BBA_FILES=${OUTPUT_DIR}/bba-files \
      -B build
make -C build nextpnr-all-bba
