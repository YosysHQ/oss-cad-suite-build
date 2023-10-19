cd numpy
source ${PATCHES_DIR}/python3_package.sh
python3_package_setup
python3_package_pip_install "Cython"
if [ ${ARCH_BASE} == 'windows' ]; then
    patch -p1 < ${PATCHES_DIR}/mingw-numpy.patch
fi
python3_package_install_numpy
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.11/site-packages/bin
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/f2py*
