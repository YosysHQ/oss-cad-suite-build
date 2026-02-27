mkdir -p boolector/deps/install
cp -r btor2tools/${INSTALL_PREFIX}/* boolector/deps/install/.
cp -r cadical/${INSTALL_PREFIX}/* boolector/deps/install/.
cp -r lingeling/${INSTALL_PREFIX}/* boolector/deps/install/.
cd boolector

if [ ${ARCH_BASE} == 'windows' ]; then
    export CMAKE_TOOLCHAIN_FILE=${PATCHES_DIR}/Toolchain-mingw64.cmake
    mkdir -p build
    cd build
    cmake .. -DPYTHON=OFF -DIS_WINDOWS_BUILD=1 -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
    cd ..
else
    sed -i -re "s,cmake ..,cmake .. -DCMAKE_TOOLCHAIN_FILE=\${CMAKE_TOOLCHAIN_FILE},g" ./configure.sh
    ./configure.sh --prefix ${INSTALL_PREFIX} -fPIC
fi
cd build
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
cp ../../btor2tools/${INSTALL_PREFIX}/bin/btorsim${EXE} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/
${STRIP} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/btorsim${EXE}
cd ..
# Need to expose like this since smt-switch and pono use build tree instead of installed libs
mkdir -p ${OUTPUT_DIR}/dev
mkdir -p ${OUTPUT_DIR}/dev/build/lib
mkdir -p ${OUTPUT_DIR}/dev/deps/lingeling/build
mkdir -p ${OUTPUT_DIR}/dev/deps/cadical/build
mkdir -p ${OUTPUT_DIR}/dev/deps/btor2tools/build/lib
mkdir -p ${OUTPUT_DIR}/dev/deps/btor2tools/src/btor2parser
cp -r src ${OUTPUT_DIR}/dev/.
cp -r build/lib/libboolector.a ${OUTPUT_DIR}/dev/build/lib/libboolector.a
cp -r deps/install/lib/liblgl.a ${OUTPUT_DIR}/dev/deps/lingeling/build/liblgl.a
cp -r deps/install/lib/libcadical.a ${OUTPUT_DIR}/dev/deps/cadical/build/libcadical.a
cp -r deps/install/lib/libbtor2parser.a ${OUTPUT_DIR}/dev/deps/btor2tools/build/lib/libbtor2parser.a
cp -r deps/install/include/btor2parser.h ${OUTPUT_DIR}/dev/deps/btor2tools/src/btor2parser/btor2parser.h
# Do not expose includes and libs in final package
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/include
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
