cd fujprog
if [ ${ARCH} == 'windows-x64' ]; then
    cp -f ftd2xx-amd64.lib ftd2xx.lib
    export CMAKE_TOOLCHAIN_FILE=${PATCHES_DIR}/Toolchain-mingw64.cmake
fi
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} .
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
