cd nextpnr
build_gui="OFF"
if [ ${ARCH} == 'linux-x64' ] || [ ${ARCH} == 'windows-x64' ] || [ ${ARCH} == 'darwin-x64' ] || [ ${ARCH} == 'darwin-arm64' ]; then
      build_gui="ON"
fi
source ${PATCHES_DIR}/python3_package.sh
python3_package_setup
python3_package_pip_install "apycula"
cmake -DPython3_EXECUTABLE=${BUILD_DIR}/python3-native${INSTALL_PREFIX}/bin/python3.11 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DPython3_INCLUDE_DIR=${BUILD_DIR}/python3${INSTALL_PREFIX}/include/python3.11 \
      -DPython3_LIBRARY=${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/libpython3.11${SHARED_EXT} \
      -DARCH=himbaechel \
      -DHIMBAECHEL_GOWIN_DEVICES=all \
      -DBUILD_GUI=${build_gui} -DUSE_IPO=OFF . -DBBA_IMPORT=${BUILD_DIR}/nextpnr-bba/nextpnr/bba/bba-export.cmake
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
${STRIP} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/nextpnr-himbaechel${EXE}
