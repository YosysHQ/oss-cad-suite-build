mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts ${OUTPUT_DIR}${INSTALL_PREFIX}/share/fonts
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins

if [ ${ARCH_BASE} == 'linux' ]; then
    # Linux section
    if [ ${ARCH} == 'linux-x64' ]; then
        arch_prefix="x86_64-linux-gnu"
    elif [ ${ARCH} == 'linux-arm64' ]; then
        arch_prefix="aarch64-linux-gnu"
    elif [ ${ARCH} == 'linux-arm' ]; then
        arch_prefix="arm-linux-gnueabihf"
    elif [ ${ARCH} == 'linux-riscv64' ]; then
        arch_prefix="riscv64-linux-gnu"
    fi
    
    cp ${PATCHES_DIR}/environment ${OUTPUT_DIR}${INSTALL_PREFIX}/.

    cp -r /usr/share/fonts/. ${OUTPUT_DIR}${INSTALL_PREFIX}/share/fonts
    cp -r /etc/fonts/.   ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts
    rm ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts/fonts.conf
    cp ${PATCHES_DIR}/setup.sh ${OUTPUT_DIR}${INSTALL_PREFIX}/.
    cp ${PATCHES_DIR}/fonts.conf.template ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts/.
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    cp -r /usr/share/tcltk/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
    cp -r /usr/share/tcltk/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6
    cp -rL /usr/lib/${CROSS_NAME}/libtcl8.6.so ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    cp -rL /usr/lib/${CROSS_NAME}/libtk8.6.so ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.

    cp -rv /usr/lib/${CROSS_NAME}/qt5/plugins/* ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins/.
    cp -rvL /usr/lib/${CROSS_NAME}/libQt5*.so.5 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/modules
    cp -v `pkg-config --variable=gdk_pixbuf_moduledir gdk-pixbuf-2.0`/* ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    cp -v `pkg-config --variable=gdk_pixbuf_cache_file gdk-pixbuf-2.0` ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/.
    sed -i -re "s,$(pkg-config --variable=gdk_pixbuf_moduledir gdk-pixbuf-2.0)/,,g" ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/loaders.cache
    touch ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/gtkrc
    cp -rvL /usr/lib/${CROSS_NAME}/libgtk*.so.0 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    
    cp -rL /usr/lib/${CROSS_NAME}/libboost_*.so.1.*  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    cp -rL /usr/lib/${CROSS_NAME}/libftdi1.so.2  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    cp -rL /usr/lib/${CROSS_NAME}/libhidapi-*.so.0  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    cp -rL /usr/lib/${CROSS_NAME}/libreadline.so.8  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    cp -rL /usr/lib/${CROSS_NAME}/libutil.so.1  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    cp -rL /usr/lib/${CROSS_NAME}/libcrypt.so.1  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    cp -rL /usr/lib/${CROSS_NAME}/libssl.so.1.1  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    cp -rL /usr/lib/${CROSS_NAME}/libpanelw.so.6 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    cp -rL /usr/lib/${CROSS_NAME}/libncursesw.so.6 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.

    for lib in /lib/$arch_prefix/libnss_dns.so.2 /lib/$arch_prefix/libnss_files.so.2 /lib/$arch_prefix/libnss_compat.so.2 /lib/$arch_prefix/libresolv.so.2 \
            /lib/$arch_prefix/libnss_nis.so.2 /lib/$arch_prefix/libnss_nisplus.so.2 /lib/$arch_prefix/libnss_hesiod.so.2 /lib/$arch_prefix/libnsl.so.1; do
        cp "${lib}" ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    done

    for libdir in ${OUTPUT_DIR}${INSTALL_PREFIX}/lib; do
        for libfile in $(find $libdir -type f | xargs file | grep ELF | grep dynamically | cut -f1 -d:); do
            for lib in $(lddtree -l $libfile | tail -n +2 | grep ^/ ); do
                cp -i "${lib}" ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
            done
        done
    done
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
