cd prjpeppercorn/libgm
sed -i 's,cmake_policy(SET CMP0167 NEW),,g' CMakeLists.txt
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      .
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
