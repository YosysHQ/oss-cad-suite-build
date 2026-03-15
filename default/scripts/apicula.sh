cd apicula
source ${PATCHES_DIR}/python3_package.sh
python3_package_setup
python3_package_pip_install "fastcrc"
python3_package_pip_install "msgpack"
python3_package_install_numpy
curl -L https://github.com/YosysHQ/apicula/releases/download/0.0.0.dev/linux-x64-gowin-data.tgz > linux-x64-gowin-data.tgz
tar xvfz linux-x64-gowin-data.tgz
python3_package_install --old-and-unmanageable
