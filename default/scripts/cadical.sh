cd cadical
if [ ${ARCH_BASE} == 'windows' ]; then
    git checkout cb89cbfa16f47cb7bf1ec6ad9855e7b6d5203c18
    patch -p1 < ${PATCHES_DIR}/CaDiCaL_20190730.patch
fi
if [ ${ARCH} == 'linux-arm64' ]; then
    sed -i '318,436d' configure
fi
if [ ${ARCH_BASE} == 'darwin' ]; then
    sed -i '318,436d' configure
fi
if [ ${ARCH_BASE} == 'windows' ]; then
    sed -i '247,347d' configure
    export CXXFLAGS=""
    EXTRA_FLAGS="-q"
else
    export CXXFLAGS="-fPIC"
fi
./configure ${EXTRA_FLAGS}
make -j${NPROC}
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/include
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
cp src/ccadical.h ${OUTPUT_DIR}${INSTALL_PREFIX}/include/.
cp src/cadical.hpp ${OUTPUT_DIR}${INSTALL_PREFIX}/include/.
cp build/libcadical.a ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
