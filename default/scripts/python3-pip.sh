mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/bin
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages
export _PYTHON_PROJECT_BASE=${BUILD_DIR}/python3${INSTALL_PREFIX}
export PYTHONHOME=${BUILD_DIR}/python3${INSTALL_PREFIX}
export PYTHONPATH=${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/python3.8:${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/python3.8/site-packages
pip_cmd="pip install --target ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages --no-cache-dir --disable-pip-version-check flask"
if [ ${ARCH} == 'linux-arm' ]; then
	cp /usr/lib/python3.8/lib-dynload/* ${PYTHONHOME}/lib/python3.8/lib-dynload/.
	_PYTHON_HOST_PLATFORM=linux-arm  _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_arm-linux-gnueabihf python3.8 -m ${pip_cmd}
elif [ ${ARCH} == 'linux-arm64' ]; then
	cp /usr/lib/python3.8/lib-dynload/* ${PYTHONHOME}/lib/python3.8/lib-dynload/.
	_PYTHON_HOST_PLATFORM=linux-aarch64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_aarch64-linux-gnu python3.8 -m ${pip_cmd}
elif [ ${ARCH} == 'linux-riscv64' ]; then
	cp /usr/lib/python3.8/lib-dynload/* ${PYTHONHOME}/lib/python3.8/lib-dynload/.
	_PYTHON_HOST_PLATFORM=linux-riscv64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_riscv64-linux-gnu python3.8 -m ${pip_cmd}
elif [ ${ARCH} == 'linux-x64' ]; then
	${PYTHONHOME}/py3bin/python3 -m ${pip_cmd} xdot==1.1 pycairo PyGObject
elif [ ${ARCH} == 'windows-x64' ]; then
	export DLLWRAP=x86_64-w64-mingw32-dllwrap 
	export PYTHONPATH=${PYTHONPATH}:/usr/lib/python3.8/site-packages
	export HOME=/tmp
	cp /usr/lib64/python3.8/lib-dynload/* ${PYTHONHOME}/lib/python3.8/lib-dynload/.
	cp -r ${BUILD_DIR}/python3${INSTALL_PREFIX}/lib ${BUILD_DIR}/python3${INSTALL_PREFIX}/lib64
	_PYTHON_HOST_PLATFORM=mingw-x64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__win_ python3.8 -m ${pip_cmd} setuptools pip

	mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/py3bin
	cp ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages/bin/pip* ${OUTPUT_DIR}${INSTALL_PREFIX}/py3bin/.
elif [ ${ARCH} == 'darwin-x64' ]; then
	DYLD_LIBRARY_PATH=${PYTHONHOME}/lib ${PYTHONHOME}/py3bin/python3 -m ${pip_cmd} xdot==1.1 pycairo PyGObject
fi
if [ -f "${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages/bin/xdot" ]; then
	cp ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages/bin/xdot ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.
fi
