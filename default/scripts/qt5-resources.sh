if [ ${IS_LOCAL} == 'True' ]; then
    exit
fi
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins
if [ ${ARCH_BASE} == 'linux' ]; then
    cp -rv /usr/lib/${CROSS_NAME}/qt5/plugins/* ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins/.
fi
if [ ${ARCH_BASE} == 'windows' ]; then
    cp -rv /mingw64/share/qt5/plugins/* ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins/.
fi
