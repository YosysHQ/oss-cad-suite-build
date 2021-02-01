mkdir -p pono/deps/smt-switch/local
cp -R ${BUILD_DIR}/smt-switch${INSTALL_PREFIX}/* pono/deps/smt-switch/local/.
cp -R pono/deps/smt-switch/local/cmake pono/deps/smt-switch/.
cd pono
./contrib/setup-bison.sh
./contrib/setup-btor2tools.sh
./configure.sh
cd build
make -j${NPROC}
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/bin
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
cp pono ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.
if [ ${ARCH_BASE} == 'linux' ]; then
    cp libpono.so ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
fi
