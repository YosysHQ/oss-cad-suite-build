mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins

if [ ${ARCH_BASE} == 'linux' ]; then
    # Linux section
    cp ${PATCHES_DIR}/environment ${OUTPUT_DIR}${INSTALL_PREFIX}/.

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts ${OUTPUT_DIR}${INSTALL_PREFIX}/share/fonts
    cp -r /usr/share/fonts/. ${OUTPUT_DIR}${INSTALL_PREFIX}/share/fonts
    cp -r /etc/fonts/.   ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts
    rm ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts/fonts.conf
    cp ${PATCHES_DIR}/fonts.conf.template ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts/.

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    cp -r /usr/share/tcltk/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
    cp -r /usr/share/tcltk/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6

    cp -rv /usr/lib/${CROSS_NAME}/qt5/plugins/* ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins/.

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec
    cp -v `pkg-config --variable=gdk_pixbuf_binarydir gdk-pixbuf-2.0`/../gdk-pixbuf-query-loaders ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec/.
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/modules
    cp -r `pkg-config --variable=gdk_pixbuf_binarydir gdk-pixbuf-2.0`/loaders ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/.
    cp -v `pkg-config --variable=gdk_pixbuf_cache_file gdk-pixbuf-2.0` ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/.
    touch ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/gtkrc
fi

if [ ${ARCH_BASE} == 'darwin' ]; then
    cp ${PATCHES_DIR}/environment ${OUTPUT_DIR}${INSTALL_PREFIX}/.

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/Frameworks
    cp -r /opt/Qt5.12.8/lib/*.framework ${OUTPUT_DIR}${INSTALL_PREFIX}/Frameworks/.
    cp -rv /opt/Qt5.12.8/plugins/* ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins/.
    find  ${OUTPUT_DIR}${INSTALL_PREFIX}/Frameworks -type d -name Headers -prune -exec rm -rf {} +
    find  ${OUTPUT_DIR}${INSTALL_PREFIX}/Frameworks -type l -name Headers -prune -exec rm -rf {} +

    cp -r /opt/local/lib/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
    cp -r /opt/local/lib/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec
    cp /opt/local/bin/gdk-pixbuf-query-loaders ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec/.
    chmod 755 ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec/gdk-pixbuf-query-loaders
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/modules
    cp -r -L /opt/local/lib/gdk-pixbuf-2.0/2.10.0/loaders ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/.
    cp -v -L /opt/local/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/.
    chmod 644 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/loaders/*
    dylibbundler -of -b -x ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec/gdk-pixbuf-query-loaders -p @executable_path/../lib -d ${OUTPUT_DIR}${INSTALL_PREFIX}/lib

fi
if [ ${ARCH_BASE} == 'windows' ]; then
    ${CC} -DGUI=0 -O -s -o ${OUTPUT_DIR}${INSTALL_PREFIX}/win-launcher.exe ${PATCHES_DIR}/win-launcher.c

    cp ${PATCHES_DIR}/environment.bat ${OUTPUT_DIR}${INSTALL_PREFIX}/.
    cp ${PATCHES_DIR}/start.bat ${OUTPUT_DIR}${INSTALL_PREFIX}/.
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    cp /usr/x86_64-w64-mingw32/sys-root/mingw/bin/gdk-pixbuf-query-loaders.exe ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    cp -r /usr/x86_64-w64-mingw32/sys-root/mingw/lib/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
    cp -r /usr/x86_64-w64-mingw32/sys-root/mingw/lib/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6/tclConfig.sh
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6/tkConfig.sh

    cp -rv /usr/x86_64-w64-mingw32/sys-root/mingw/lib/qt5/plugins/* ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins/.

	mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    cp -rf /usr/x86_64-w64-mingw32/sys-root/mingw/lib/gdk-pixbuf-2.0 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
fi
