source ${PATCHES_DIR}/python3_package.sh
python3_package_setup
python3_package_pip_install "setuptools"
pushd mau
python3_package_install
python3_package_pth "mau"
