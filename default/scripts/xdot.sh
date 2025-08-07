source ${PATCHES_DIR}/python3_package.sh
python3_package_setup
python3_package_pip_install "xdot==1.1 pycairo==1.25.1"
wget https://files.pythonhosted.org/packages/ac/4a/f24ddf1d20cc4b56affc7921e29928559a06c922eb60077448392792b914/PyGObject-3.46.0.tar.gz
tar xvfz PyGObject-3.46.0.tar.gz
cd PyGObject-3.46.0
python3_package_install
python3_package_pth "xdot"
mv ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.11/site-packages/bin ${OUTPUT_DIR}${INSTALL_PREFIX}
if [ ${ARCH_BASE} == 'linux' ]; then
	cp -r /usr/lib/x86_64-linux-gnu/girepository-1.0 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
elif [ ${ARCH_BASE} == 'darwin' ]; then
	cp -r /opt/local/lib/girepository-1.0 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
fi
