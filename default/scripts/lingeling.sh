cd lingeling
if [ ${ARCH_BASE} == 'windows' ]; then
    git checkout 03b4860d14016f42213ea271014f2f13d181f504
    patch -p1 < ${PATCHES_DIR}/Lingeling_20190110.patch
fi

./configure.sh -fPIC
make -j${NPROC}
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/include
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
cp lglib.h ${OUTPUT_DIR}${INSTALL_PREFIX}/include/.
cp liblgl.a ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
