source ${PATCHES_DIR}/python3_package.sh
python3_package_setup
python3_package_pip_install "git+https://github.com/amaranth-lang/amaranth"
python3_package_pip_install "git+https://github.com/amaranth-lang/amaranth-boards"
python3_package_pip_install "git+https://github.com/m-labs/migen"
mv ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.11/site-packages/bin ${OUTPUT_DIR}${INSTALL_PREFIX}/.

