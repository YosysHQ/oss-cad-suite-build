if [ ${ARCH_BASE} == 'windows' ]; then
    pushd lingeling
    git checkout 03b4860d14016f42213ea271014f2f13d181f504
    popd
    pushd cadical
    git checkout cb89cbfa16f47cb7bf1ec6ad9855e7b6d5203c18
    popd
fi
cd boolector
patch -p1 < ${PATCHES_DIR}/boolector.diff
if [ ${ARCH} == 'linux-arm' ] || [ ${ARCH} == 'linux-arm64' ] || [ ${ARCH} == 'linux-riscv64' ]; then
    sed -i '286,407d' ../cadical/configure
fi
if [ ${ARCH_BASE} == 'windows' ]; then
    sed -i -re "s,MINGW32,Linux,g" contrib/setup-utils.sh
    sed -i -re "s,cmake ..,cmake .. -DCMAKE_TOOLCHAIN_FILE=\${CMAKE_TOOLCHAIN_FILE} -DCMAKE_CXX_FLAGS=\"-D__STDC_FORMAT_MACROS=1\",g" ../btor2tools/configure.sh
    sed -i '247,347d' ../cadical/configure
    export CMAKE_TOOLCHAIN_FILE=${PATCHES_DIR}/Toolchain-mingw64.cmake
fi
sed -i -re "s,test_apply_patch,#test_apply_patch,g" contrib/setup-btor2tools.sh
sed -i -re "s,./configure,CXXFLAGS=-fPIC CFLAGS=-fPIC ./configure,g" contrib/setup-btor2tools.sh

bash contrib/setup-btor2tools.sh
bash contrib/setup-lingeling.sh
bash contrib/setup-cadical.sh
if [ ${ARCH_BASE} == 'windows' ]; then
    mkdir -p build
    cd build
    cmake .. -DPYTHON=OFF -DIS_WINDOWS_BUILD=1 -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
    cd ..
else
    ./configure.sh --prefix ${INSTALL_PREFIX} -fPIC
fi
cd build
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
if [ ${ARCH_BASE} = 'linux' ]; then
    cd ..
    mkdir -p ${OUTPUT_DIR}/dev
    mkdir -p ${OUTPUT_DIR}/dev/build/lib
    mkdir -p ${OUTPUT_DIR}/dev/deps/lingeling/build
    mkdir -p ${OUTPUT_DIR}/dev/deps/cadical/build
    mkdir -p ${OUTPUT_DIR}/dev/deps/btor2tools/build
    mkdir -p ${OUTPUT_DIR}/dev/deps/btor2tools/src    
    cp -r src ${OUTPUT_DIR}/dev/.
    cp -r build/lib/libboolector.a ${OUTPUT_DIR}/dev/build/lib/libboolector.a
    cp -r deps/install/lib/liblgl.a ${OUTPUT_DIR}/dev/deps/lingeling/build/liblgl.a
    cp -r deps/install/lib/libcadical.a ${OUTPUT_DIR}/dev/deps/cadical/build/libcadical.a
    cp -r deps/install/lib/libbtor2parser.a ${OUTPUT_DIR}/dev/deps/btor2tools/build/libbtor2parser.a
    cp -r ../btor2tools/src ${OUTPUT_DIR}/dev/deps/btor2tools/.
fi
