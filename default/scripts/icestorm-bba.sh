cd nextpnr
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DICEBOX_DATADIR=${BUILD_DIR}/icestorm${INSTALL_PREFIX}/share/icebox \
      -DARCH=ice40 \
      -DEXPORT_BBA_FILES=${OUTPUT_DIR}/bba-files \
      -B build
make -C build nextpnr-all-bba
