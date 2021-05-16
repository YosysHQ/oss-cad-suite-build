mkdir -p pono/deps/smt-switch/local
mkdir -p pono/deps/btor2tools/build/lib
cp -R ${BUILD_DIR}/smt-switch${INSTALL_PREFIX}/* pono/deps/smt-switch/local/.
cp -R ${BUILD_DIR}/boolector/dev/deps/btor2tools/src pono/deps/btor2tools/.
cp -R pono/deps/smt-switch/local/cmake pono/deps/smt-switch/.
cp boolector/dev/deps/btor2tools/build/libbtor2parser.a pono/deps/btor2tools/build/lib/.
cp boolector/dev/deps/lingeling/build/liblgl.a pono/deps/smt-switch/local/lib/.
cp boolector/dev/deps/cadical/build/libcadical.a pono/deps/smt-switch/local/lib/.
cd pono
sed -i -re 's,cmake \"\$root_dir\" \$cmake_opts,cmake \"\$root_dir\" \$cmake_opts -DCMAKE_TOOLCHAIN_FILE=\$\{CMAKE_TOOLCHAIN_FILE\},g' configure.sh
sed -i 's,target_link_libraries(pono-lib PUBLIC "${SMT_SWITCH_DIR}/local/lib/libsmt-switch-btor.a"),target_link_libraries(pono-lib PUBLIC "${SMT_SWITCH_DIR}/local/lib/libsmt-switch-btor.a")\ntarget_link_libraries(pono-lib PUBLIC "${SMT_SWITCH_DIR}/local/lib/liblgl.a")\ntarget_link_libraries(pono-lib PUBLIC "${SMT_SWITCH_DIR}/local/lib/libcadical.a"),g' CMakeLists.txt 
if [ ${ARCH_BASE} == 'windows' ]; then
    sed -i -re 's,FMT_USE_WINDOWS_H 1,FMT_USE_WINDOWS_H 0,g' contrib/fmt/format.h
    sed -i -re 's,SIGALRM,SIGABRT,g' pono.cpp
fi
./configure.sh --static-lib
cd build
make -j${NPROC}
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/bin
cp pono${EXE} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.
