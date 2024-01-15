source ${PATCHES_DIR}/python3_package.sh
python3_package_setup
python3_package_pip_install "Werkzeug==2.3.7"
python3_package_pip_install "flask==2.1.2"
cd mcy
sed -i -re "s,cmake,cmake -DCMAKE_TOOLCHAIN_FILE=\${CMAKE_TOOLCHAIN_FILE},g" Makefile
make PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} -j${NPROC} install
${STRIP} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/mcy-gui${EXE}
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/mcy_demo
cp -r examples/* ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/mcy_demo/.
