mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins

if [ ${ARCH_BASE} == 'linux' ]; then
    # Linux section
    cp ${PATCHES_DIR}/environment ${OUTPUT_DIR}${INSTALL_PREFIX}/.
    cp ${PATCHES_DIR}/setup.sh ${OUTPUT_DIR}${INSTALL_PREFIX}/.

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts ${OUTPUT_DIR}${INSTALL_PREFIX}/share/fonts
    cp -r /usr/share/fonts/. ${OUTPUT_DIR}${INSTALL_PREFIX}/share/fonts
    cp -r /etc/fonts/.   ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts
    rm ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts/fonts.conf
    cp ${PATCHES_DIR}/fonts.conf.template ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts/.

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    cp -r /usr/share/tcltk/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
    cp -r /usr/share/tcltk/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6

    cp -rv /usr/lib/${CROSS_NAME}/qt5/plugins/* ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins/.

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/modules
    cp -v `pkg-config --variable=gdk_pixbuf_moduledir gdk-pixbuf-2.0`/* ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    cp -v `pkg-config --variable=gdk_pixbuf_cache_file gdk-pixbuf-2.0` ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/.
    sed -i -re "s,$(pkg-config --variable=gdk_pixbuf_moduledir gdk-pixbuf-2.0)/,,g" ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/loaders.cache
    touch ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/gtkrc
fi

if [ ${ARCH_BASE} == 'darwin' ]; then
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    cp -r $(brew --prefix tcl-tk)/lib/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
    cp -r $(brew --prefix tcl-tk)/lib/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec
    cp /usr/local/bin/gdk-pixbuf-query-loaders ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec/.
    chmod 755 ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec/gdk-pixbuf-query-loaders
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/modules
    cp -r -L /usr/local/lib/gdk-pixbuf-2.0/2.10.0/loaders ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/.
    cp -v -L /usr/local/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/.
    chmod 644 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/loaders/*
    dylibbundler -of -b -x ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec/gdk-pixbuf-query-loaders -p @executable_path/../lib -d ${OUTPUT_DIR}${INSTALL_PREFIX}/lib

fi
if [ ${ARCH_BASE} == 'windows' ]; then
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    cp -r /usr/x86_64-w64-mingw32/sys-root/mingw/lib/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
    cp -r /usr/x86_64-w64-mingw32/sys-root/mingw/lib/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6/tclConfig.sh
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6/tkConfig.sh

    cp -rv /usr/x86_64-w64-mingw32/sys-root/mingw/lib/qt5/plugins/* ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins/.

	mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    cp -rf /usr/x86_64-w64-mingw32/sys-root/mingw/lib/gdk-pixbuf-2.0 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
fi
