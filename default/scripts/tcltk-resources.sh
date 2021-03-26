if [ ${ARCH_BASE} == 'darwin' ]; then
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    cp -r $(brew --prefix tcl-tk)/lib/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
    cp -r $(brew --prefix tcl-tk)/lib/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6
elif [ ${ARCH_BASE} == 'windows' ]; then
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    if [ ${IS_NATIVE} == 'True' ]; then
        cp -r /mingw64/lib/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
        cp -r /mingw64/lib/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6
    else
        cp -r /usr/x86_64-w64-mingw32/sys-root/mingw/lib/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
        cp -r /usr/x86_64-w64-mingw32/sys-root/mingw/lib/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6
        rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6/tclConfig.sh
        rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6/tkConfig.sh
    fi
else
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    cp -r /usr/share/tcltk/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
    cp -r /usr/share/tcltk/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6
fi
