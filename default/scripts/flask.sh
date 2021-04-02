cd flask
source ${PATCHES_DIR}/python3_package.sh
python3_package_setup
python3_package_install
python3_package_pth "flask"
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/bin
