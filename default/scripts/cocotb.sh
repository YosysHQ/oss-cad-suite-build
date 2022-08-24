source ${PATCHES_DIR}/python3_package.sh
python3_package_setup
sed -i -re "s,sys.platform == \"darwin\",sysconfig.get_platform() == \"darwin-x64\",g" cocotb/cocotb_build_libs.py
pushd cocotb
python3_package_install
python3_package_pth "cocotb"
python3_package_pip_install "pytest"
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages/cocotb/share/makefiles/simulators/Makefile.verilator
