source ${PATCHES_DIR}/python3_package.sh
python3_package_setup
# scy
cd  ${BUILD_DIR}/scy
sed -i 's,"yosys_mau,#"yosys_mau,g' pyproject.toml
python3_package_pip_install "."
mv ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.11/site-packages/bin ${OUTPUT_DIR}${INSTALL_PREFIX}/.
#mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/scy
#cp -r example/* ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/scy/.

# flask
python3_package_pip_install "Werkzeug==2.3.7"
python3_package_pip_install "flask==2.1.2"
if [ ${ARCH_BASE} == 'windows' ]; then
    python3_package_pip_install "colorama"
fi
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.11/site-packages/bin

# mau
cd ${BUILD_DIR}/mau
python3_package_install
python3_package_pth "formal"

# mcy
cd  ${BUILD_DIR}/mcy
sed -i -re "s,cmake,cmake -DCMAKE_TOOLCHAIN_FILE=\${CMAKE_TOOLCHAIN_FILE},g" Makefile
make PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} -j${NPROC} install
${STRIP} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/mcy-gui${EXE}
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/mcy_demo
cp -r examples/* ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/mcy_demo/.

# sby
cd  ${BUILD_DIR}/sby
make PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} -j${NPROC} install
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/examples
cp -r docs/examples/* ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/.
find ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/ -name "Makefile" -type f -delete
find ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/ -name ".gitignore" -type f -delete
cargo install --no-track --path tools/aigcexmin --root ${OUTPUT_DIR}${INSTALL_PREFIX} --target=${CARGO_TARGET}

# sby-gui
cd ${BUILD_DIR}/sby-gui
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} .
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
${STRIP} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/sby-gui${EXE}
