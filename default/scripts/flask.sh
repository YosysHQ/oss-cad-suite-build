cd flask
source ${PATCHES_DIR}/python3_package.sh
sed -i 's,Werkzeug >= 2.0,Werkzeug == 2.3.7,g' setup.py
python3_package_setup
python3_package_install
python3_package_pth "flask"
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/bin
