cd sby
make PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} -j${NPROC} install
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/examples
cp -r docs/examples/* ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/.
source ${PATCHES_DIR}/python3_package.sh
python3_package_setup
python3_package_pip_install "xmlschema"
