mkdir -p pono/deps/smt-switch/local
mkdir -p pono/deps/btor2tools/build/lib
cp -R ${BUILD_DIR}/smt-switch${INSTALL_PREFIX}/* pono/deps/smt-switch/local/.
cp -R ${BUILD_DIR}/boolector/dev/deps/btor2tools/src pono/deps/btor2tools/.
cp -R pono/deps/smt-switch/local/cmake pono/deps/smt-switch/.
cp boolector/dev/deps/btor2tools/build/libbtor2parser.a pono/deps/btor2tools/build/lib/.
cp boolector/dev/deps/lingeling/build/liblgl.a pono/deps/smt-switch/local/lib/.
cd pono
sed -i -re 's,./configure,./configure --host=\$\{CROSS_NAME\},g' contrib/setup-bison.sh
sed -i -re 's,cmake \"$root_dir\" \$cmake_opts,cmake \"$root_dir\" \$cmake_opts -DCMAKE_TOOLCHAIN_FILE=\$\{CMAKE_TOOLCHAIN_FILE\},g' CMakeLists.txt 
sed -i 's,target_link_libraries(pono-lib PUBLIC "${SMT_SWITCH_DIR}/local/lib/libsmt-switch-btor.a"),target_link_libraries(pono-lib PUBLIC "${SMT_SWITCH_DIR}/local/lib/libsmt-switch-btor.a")\ntarget_link_libraries(pono-lib PUBLIC "${SMT_SWITCH_DIR}/local/lib/liblgl.a"),g' CMakeLists.txt 
./configure.sh
cd build
make -j${NPROC}
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/bin
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
cp pono ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.
if [ ${ARCH_BASE} == 'linux' ]; then
    cp libpono.so ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
fi
if [ ${ARCH_BASE} == 'darwin' ]; then
    cp libpono.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    install_name_tool -add_rpath ${OUTPUT_DIR}${INSTALL_PREFIX}/lib ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/pono
fi
