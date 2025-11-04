mkdir -p pono/deps/smt-switch/local
mkdir -p pono/deps/btor2tools/build/lib
mkdir -p pono/deps/bitwuzla
cp -R ${BUILD_DIR}/smt-switch${INSTALL_PREFIX}/* pono/deps/smt-switch/local/.
cp -R ${BUILD_DIR}/boolector/dev/deps/btor2tools/src pono/deps/btor2tools/.
cp -R pono/deps/smt-switch/local/cmake pono/deps/smt-switch/.
cp -R ${BUILD_DIR}/bitwuzla/dev/lib/x86_64-linux-gnu/* pono/deps/bitwuzla/.
cp boolector/dev/deps/btor2tools/build/lib/libbtor2parser.a pono/deps/btor2tools/build/lib/.
cp boolector/dev/deps/lingeling/build/liblgl.a pono/deps/smt-switch/local/lib/.
cp boolector/dev/deps/cadical/build/libcadical.a pono/deps/smt-switch/local/lib/.
cd pono
sed -i -re 's,cmake \"\$root_dir\" \$cmake_opts,cmake \"\$root_dir\" \$cmake_opts -DCMAKE_TOOLCHAIN_FILE=\$\{CMAKE_TOOLCHAIN_FILE\},g' configure.sh
sed -i 's,target_link_libraries(pono-lib PUBLIC "${SMT_SWITCH_DIR}/local/lib/libsmt-switch-btor.a"),target_link_libraries(pono-lib PUBLIC "${SMT_SWITCH_DIR}/local/lib/libsmt-switch-btor.a")\ntarget_link_libraries(pono-lib PUBLIC "${SMT_SWITCH_DIR}/local/lib/liblgl.a")\ntarget_link_libraries(pono-lib PUBLIC "${SMT_SWITCH_DIR}/local/lib/libcadical.a"),g' CMakeLists.txt 
sed -i 's,add_subdirectory(tests),#add_subdirectory(tests),g' CMakeLists.txt 
if [ ${ARCH_BASE} == 'windows' ]; then
    sed -i 's,#include <string>,#include <string>\n#include <cstdint>,g' utils/str_util.h
    cp ../cvc5/dev/build/src/main/libcvc5.dll.a ../pono/deps/smt-switch/local/lib/.
    sed -i 's,target_link_libraries(pono-lib PUBLIC "${SMT_SWITCH_DIR}/local/lib/libsmt-switch-cvc5.a"),target_link_libraries(pono-lib PUBLIC "${SMT_SWITCH_DIR}/local/lib/libsmt-switch-cvc5.a")\ntarget_link_libraries(pono-lib PUBLIC "${SMT_SWITCH_DIR}/local/lib/libcvc5.dll.a"),g' CMakeLists.txt 
    sed -i -re 's,FMT_USE_WINDOWS_H 1,FMT_USE_WINDOWS_H 0,g' contrib/fmt/format.h
    sed -i -re 's,SIGALRM,SIGABRT,g' pono.cpp
fi
export LDFLAGS="-L${BUILD_DIR}/pono/deps/bitwuzla $LDFLAGS"
export CMAKE_PREFIX_PATH="${BUILD_DIR}/pono/deps/bitwuzla:$CMAKE_PREFIX_PATH"
export PKG_CONFIG_PATH="${BUILD_DIR}/pono/deps/bitwuzla/pkgconfig:$PKG_CONFIG_PATH"
./configure.sh --static-lib --prefix=${INSTALL_PREFIX}
cd build
make -j${NPROC}
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/bin
cp pono${EXE} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.
