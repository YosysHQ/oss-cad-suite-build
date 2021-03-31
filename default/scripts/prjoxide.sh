cd prjoxide/libprjoxide
if [ ${ARCH} == 'linux-arm' ]; then
    param="--target=arm-unknown-linux-gnueabihf"
elif [ ${ARCH} == 'linux-arm64' ]; then
    param="--target=aarch64-unknown-linux-gnu"
elif [ ${ARCH} == 'linux-riscv64' ]; then
	param="--target=riscv64gc-unknown-linux-gnu"
elif [ ${ARCH} == 'linux-x64' ]; then
    param=""
elif [ ${ARCH} == 'darwin-x64' ]; then
    param=""
elif [ ${ARCH} == 'windows-x64' ]; then
    param="--target=x86_64-pc-windows-gnu"
fi
HOME=/tmp cargo install --no-track --path prjoxide --root ${OUTPUT_DIR}${INSTALL_PREFIX} ${param}
