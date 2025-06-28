export PATH=${BUILD_DIR}/python3-native${INSTALL_PREFIX}/bin:$PATH
cd nextpnr
mkdir bba-files
cp -rf ${BUILD_DIR}/apicula-bba/bba-files/* bba-files/.
cp -rf ${BUILD_DIR}/gatemate-bba/bba-files/* bba-files/.
cp -rf ${BUILD_DIR}/xilinx-bba/bba-files/* bba-files/.
build_gui="OFF"
if [ ${ARCH} == 'linux-x64' ] || [ ${ARCH} == 'windows-x64' ] || [ ${ARCH} == 'darwin-x64' ] || [ ${ARCH} == 'darwin-arm64' ]; then
      build_gui="ON"
fi
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DPython3_INCLUDE_DIR=${BUILD_DIR}/python3${INSTALL_PREFIX}/include/python3.11 \
      -DPython3_LIBRARY=${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/libpython3.11${SHARED_EXT} \
      -DARCH=himbaechel -DHIMBAECHEL_UARCH="gowin;gatemate;xilinx" \
      -DIMPORT_BBA_FILES=${BUILD_DIR}/nextpnr/bba-files \
      -DBUILD_GUI=${build_gui} -DUSE_IPO=OFF \
      -DBBA_IMPORT=${BUILD_DIR}/nextpnr-bba/nextpnr/bba/bba-export.cmake \
      -B build

make -C build DESTDIR=${OUTPUT_DIR} -j${NPROC} install

${STRIP} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/nextpnr-himbaechel${EXE}
