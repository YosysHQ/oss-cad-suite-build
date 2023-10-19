source ${PATCHES_DIR}/python3_package.sh
python3_package_setup
pushd scy
sed -i 's,"yosys_mau",#"yosys_mau",g' pyproject.toml
python3_package_pip_install "."
mv ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.11/site-packages/bin ${OUTPUT_DIR}${INSTALL_PREFIX}/.
#mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/scy
#cp -r example/* ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/scy/.
