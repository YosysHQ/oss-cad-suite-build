mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins
if [ ${ARCH_BASE} == 'linux' ]; then
    cp -rv /usr/lib/${CROSS_NAME}/qt5/plugins/* ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins/.
fi
if [ ${ARCH_BASE} == 'windows' ]; then
    cp -rv /usr/x86_64-w64-mingw32/sys-root/mingw/lib/qt5/plugins/* ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins/.
fi
