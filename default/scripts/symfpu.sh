cd symfpu
patch -p1 < ${PATCHES_DIR}/symfpu_20201114.patch
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/include/symfpu/core
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/include/symfpu/utils
cp -R core/*.h ${OUTPUT_DIR}${INSTALL_PREFIX}/include/symfpu/core/.
cp -R utils/*.h ${OUTPUT_DIR}${INSTALL_PREFIX}/include/symfpu/utils/.
