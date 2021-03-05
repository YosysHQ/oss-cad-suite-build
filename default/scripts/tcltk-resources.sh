if [ ${IS_LOCAL} == 'True' ]; then
    exit
fi
if [ ${ARCH_BASE} == 'darwin' ]; then
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    cp -r $(brew --prefix tcl-tk)/lib/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
    cp -r $(brew --prefix tcl-tk)/lib/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6
elif [ ${ARCH_BASE} == 'windows' ]; then
	mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
	cp -r /mingw64/lib/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
	cp -r /mingw64/lib/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6
else
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    cp -r /usr/share/tcltk/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
    cp -r /usr/share/tcltk/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6
fi
