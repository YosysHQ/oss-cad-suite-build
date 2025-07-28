source ${PATCHES_DIR}/python3_package.sh
python3_package_setup

# flask
python3_package_pip_install "Werkzeug==2.3.7"
python3_package_pip_install "flask==2.1.2"
if [ ${ARCH_BASE} == 'windows' ]; then
    python3_package_pip_install "colorama"
fi
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.11/site-packages/bin

# sby
cd  ${BUILD_DIR}/sby
make PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} -j${NPROC} install
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/examples
cp -r docs/examples/* ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/.
find ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/ -name "Makefile" -type f -delete
find ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/ -name ".gitignore" -type f -delete
#cargo install --no-track --path tools/aigcexmin --root ${OUTPUT_DIR}${INSTALL_PREFIX} --target=${CARGO_TARGET}
