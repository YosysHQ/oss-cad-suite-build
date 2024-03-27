source ${PATCHES_DIR}/python3_package.sh
python3_package_setup
python3_package_pip_install "xdot==1.1 pycairo==1.25.1 PyGObject==3.46.0"
mv ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.11/site-packages/bin ${OUTPUT_DIR}${INSTALL_PREFIX}
if [ ${ARCH_BASE} == 'linux' ]; then
	cp -r /usr/lib/x86_64-linux-gnu/girepository-1.0 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
elif [ ${ARCH_BASE} == 'darwin' ]; then
	cp -r /opt/local/lib/girepository-1.0 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
fi
