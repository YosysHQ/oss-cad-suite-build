source ${PATCHES_DIR}/python3_package.sh
python3_package_setup
if [ ${ARCH} == 'darwin-x64' ]; then
    sed -i -re "s,sys.platform == \"darwin\",sysconfig.get_platform() == \"darwin-x64\",g" cocotb/cocotb_build_libs.py
elif [ ${ARCH} == 'darwin-arm64' ]; then
    sed -i -re "s,sys.platform == \"darwin\",sysconfig.get_platform() == \"darwin-aarch64\",g" cocotb/cocotb_build_libs.py
fi
pushd cocotb
python3_package_install
python3_package_pth "cocotb"
python3_package_pip_install "pytest"
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.11/site-packages/cocotb/share/makefiles/simulators/Makefile.verilator
