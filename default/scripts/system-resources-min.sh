mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
if [ ${ARCH_BASE} == 'linux' ]; then
    cp ${PATCHES_DIR}/environment ${OUTPUT_DIR}${INSTALL_PREFIX}/.

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/etc
    cp ${PATCHES_DIR}/cacert.pem ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/.

    cp -r /usr/share/tcltk/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
    cp -r /usr/share/tcltk/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6
fi

if [ ${ARCH_BASE} == 'darwin' ]; then
    cp ${PATCHES_DIR}/environment ${OUTPUT_DIR}${INSTALL_PREFIX}/.
    cp ${PATCHES_DIR}/activate ${OUTPUT_DIR}${INSTALL_PREFIX}/.
    chmod 755 ${OUTPUT_DIR}${INSTALL_PREFIX}/activate

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/etc
    cp ${PATCHES_DIR}/cacert.pem ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/.

    cp -r /opt/local/lib/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
    cp -r /opt/local/lib/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6

fi
if [ ${ARCH_BASE} == 'windows' ]; then
    ${CC} -DGUI=0 -O -s -o ${OUTPUT_DIR}${INSTALL_PREFIX}/win-launcher.exe ${PATCHES_DIR}/win-launcher.c

    cp ${PATCHES_DIR}/environment.bat ${OUTPUT_DIR}${INSTALL_PREFIX}/.
    cp ${PATCHES_DIR}/start.bat ${OUTPUT_DIR}${INSTALL_PREFIX}/.

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/etc
    cp ${PATCHES_DIR}/cacert.pem ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/.

    cp -r /usr/x86_64-w64-mingw32/sys-root/mingw/lib/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
    cp -r /usr/x86_64-w64-mingw32/sys-root/mingw/lib/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6/tclConfig.sh
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6/tkConfig.sh
fi
