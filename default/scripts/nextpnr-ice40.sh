cd nextpnr
build_gui="OFF"
if [ ${ARCH} == 'linux-x64' ] || [ ${ARCH} == 'windows-x64' ] || [ ${ARCH} == 'darwin-x64' ] || [ ${ARCH} == 'darwin-arm64' ]; then
      build_gui="ON"
fi
sed -i 's,'3.25','3.22',g' CMakeLists.txt
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DPython3_INCLUDE_DIR=${BUILD_DIR}/python3${INSTALL_PREFIX}/include/python3.11 \
      -DPython3_LIBRARY=${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/libpython3.11${SHARED_EXT} \
      -DARCH=ice40 \
      -DICE40_CHIPDB=${BUILD_DIR}/icestorm-bba/ice40/chipdb \
      -DBUILD_GUI=${build_gui} -DUSE_IPO=OFF . -DBBA_IMPORT=${BUILD_DIR}/nextpnr-bba/nextpnr/bba/bba-export.cmake
if [ ${ARCH} == 'darwin-arm64' ]; then
      make DESTDIR=${OUTPUT_DIR} chipdb-ice40
fi
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install

${STRIP} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/nextpnr-ice40${EXE}
