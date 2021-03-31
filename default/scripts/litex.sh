mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/bin
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages/litex
export _PYTHON_PROJECT_BASE=${BUILD_DIR}/python3${INSTALL_PREFIX}
export PYTHONHOME=${BUILD_DIR}/python3${INSTALL_PREFIX}
export PYTHONPATH=${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages:${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/python3.8:${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/python3.8/site-packages

if [ ${ARCH} == 'linux-arm' ]; then
	cp /usr/lib/python3.8/lib-dynload/* ${PYTHONHOME}/lib/python3.8/lib-dynload/.
elif [ ${ARCH} == 'linux-arm64' ]; then
	cp /usr/lib/python3.8/lib-dynload/* ${PYTHONHOME}/lib/python3.8/lib-dynload/.
elif [ ${ARCH} == 'linux-riscv64' ]; then
	cp /usr/lib/python3.8/lib-dynload/* ${PYTHONHOME}/lib/python3.8/lib-dynload/.
elif [ ${ARCH} == 'windows-x64' ]; then
	export DLLWRAP=x86_64-w64-mingw32-dllwrap 
	export PYTHONPATH=${PYTHONPATH}:/usr/lib/python3.8/site-packages
	export HOME=/tmp
	cp /usr/lib64/python3.8/lib-dynload/* ${PYTHONHOME}/lib/python3.8/lib-dynload/.
	cp -r ${BUILD_DIR}/python3${INSTALL_PREFIX}/lib ${BUILD_DIR}/python3${INSTALL_PREFIX}/lib64
fi

for target in *; do    
    if [ $target != 'python3' ]; then
        cp -r $target ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages/litex/.
    fi
done

cd ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages/litex
for target in *; do
    install_cmd="setup.py develop --prefix=${OUTPUT_DIR}${INSTALL_PREFIX} --egg-path ./litex/$target"
    pushd $target
    if [ ${ARCH} == 'linux-arm' ]; then
        _PYTHON_HOST_PLATFORM=linux-arm  _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_arm-linux-gnueabihf python3.8 ${install_cmd}
    elif [ ${ARCH} == 'linux-arm64' ]; then
        _PYTHON_HOST_PLATFORM=linux-aarch64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_aarch64-linux-gnu python3.8 ${install_cmd}
    elif [ ${ARCH} == 'linux-riscv64' ]; then
        _PYTHON_HOST_PLATFORM=linux-riscv64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__linux_riscv64-linux-gnu python3.8 ${install_cmd}
    elif [ ${ARCH} == 'linux-x64' ]; then
        ${PYTHONHOME}/py3bin/python3 ${install_cmd}
    elif [ ${ARCH} == 'windows-x64' ]; then
        _PYTHON_HOST_PLATFORM=mingw-x64 _PYTHON_SYSCONFIGDATA_NAME=_sysconfigdata__win_ python3.8 ${install_cmd}
    elif [ ${ARCH} == 'darwin-x64' ]; then
        DYLD_LIBRARY_PATH=${PYTHONHOME}/lib ${PYTHONHOME}/py3bin/python3 ${install_cmd}
    fi
    popd
done
( find . -type d -name ".git" && find . -name ".gitignore" && find . -name ".gitmodules" && find . -name ".gitattributes" && find . -name ".github" ) | xargs rm -rf
