mkdir -p bitwuzla/deps/install
cp -r btor2tools/${INSTALL_PREFIX}/* bitwuzla/deps/install/.
cp -r cadical/${INSTALL_PREFIX}/* bitwuzla/deps/install/.
cp -r lingeling/${INSTALL_PREFIX}/* bitwuzla/deps/install/.

cd bitwuzla

# Download and build SymFPU
./contrib/setup-symfpu.sh

# Build Bitwuzla
sed -i -re "s,cmake ..,cmake .. -DCMAKE_TOOLCHAIN_FILE=\${CMAKE_TOOLCHAIN_FILE},g" ./configure.sh
if [ ${ARCH_BASE} == 'windows' ]; then
    export CMAKE_TOOLCHAIN_FILE=${PATCHES_DIR}/Toolchain-mingw64.cmake
fi
./configure.sh --prefix ${INSTALL_PREFIX} -fPIC
cd build 
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
# Do not expose includes and libs in final package
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/include
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
