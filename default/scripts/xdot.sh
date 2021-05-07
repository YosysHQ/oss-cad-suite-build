source ${PATCHES_DIR}/python3_package.sh
python3_package_setup
python3_package_pip_install "xdot==1.1 pycairo PyGObject"
mv ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages/bin ${OUTPUT_DIR}${INSTALL_PREFIX}
if [ ${ARCH} == 'linux-x64' ]; then
	cp /usr/bin/dot ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.
	mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/graphviz
	cp -r /usr/lib/x86_64-linux-gnu/graphviz ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
	cp -r /usr/lib/x86_64-linux-gnu/girepository-1.0 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
elif [ ${ARCH} == 'darwin-x64' ]; then
	cp /usr/local/bin/dot ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.
	mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/graphviz
	cp -r $(brew --prefix graphviz)/lib/graphviz ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
	cp -r /usr/local/lib/girepository-1.0 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
fi
