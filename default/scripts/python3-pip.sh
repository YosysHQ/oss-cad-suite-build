mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/bin
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages
export _PYTHON_PROJECT_BASE=${BUILD_DIR}/python3${INSTALL_PREFIX}
export PYTHONHOME=${BUILD_DIR}/python3${INSTALL_PREFIX}
export PYTHONPATH=/usr/lib/python3.8/lib-dynload:${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/python3.8:${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/python3.8/site-packages
pip_cmd="pip install --target ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages --no-cache-dir --disable-pip-version-check flask xdot"
if [ ${ARCH} == 'linux-arm' ]; then
	_PYTHON_HOST_PLATFORM=linux-arm  _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_arm-linux-gnueabihf python3.8 -m ${pip_cmd}
elif [ ${ARCH} == 'linux-arm64' ]; then
	_PYTHON_HOST_PLATFORM=linux-aarch64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_aarch64-linux-gnu python3.8 -m ${pip_cmd}
elif [ ${ARCH} == 'linux-riscv64' ]; then
	_PYTHON_HOST_PLATFORM=linux-riscv64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_riscv64-linux-gnu python3.8 -m ${pip_cmd}
elif [ ${ARCH} == 'linux-x64' ]; then
	_PYTHON_HOST_PLATFORM=linux-x64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_x86_64-linux-gnu python3.8 -m ${pip_cmd}
elif [ ${ARCH} == 'windows-x64' ]; then
	export DLLWRAP=x86_64-w64-mingw32-dllwrap 
	export PYTHONPATH=/usr/lib64/python3.8/lib-dynload:${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/python3.8:/usr/lib/python3.8/site-packages
	_PYTHON_HOST_PLATFORM=mingw _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__win_ python3.8 -m ${pip_cmd} setuptools pip

	mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/py3bin
	cp ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages/bin/pip* ${OUTPUT_DIR}${INSTALL_PREFIX}/py3bin/.
elif [ ${ARCH} == 'darwin-x64' ]; then
	DYLD_LIBRARY_PATH=${BUILD_DIR}/python3 ./python.exe -m ${pip_cmd}
fi
cp ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages/bin/xdot ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.
