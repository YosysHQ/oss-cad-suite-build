if [ ${ARCH_BASE} == 'linux' ]; then
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/modules
    cp -v `pkg-config --variable=gdk_pixbuf_moduledir gdk-pixbuf-2.0`/* ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    cp -v `pkg-config --variable=gdk_pixbuf_cache_file gdk-pixbuf-2.0` ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/.
    sed -i -re "s,$(pkg-config --variable=gdk_pixbuf_moduledir gdk-pixbuf-2.0)/,,g" ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/loaders.cache
    touch ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/gtkrc
elif [ ${ARCH_BASE} == 'darwin' ]; then
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec
    cp /usr/local/bin/gdk-pixbuf-query-loaders ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec/.
    chmod 755 ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec/gdk-pixbuf-query-loaders
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/modules
    cp -r -L /usr/local/lib/gdk-pixbuf-2.0/2.10.0/loaders ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/.
    cp -v -L /usr/local/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/.
    chmod 644 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtk-2.0/loaders/*
    dylibbundler -of -b -x ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec/gdk-pixbuf-query-loaders -p @executable_path/../lib -d ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
elif [ ${ARCH_BASE} == 'windows' ]; then
	mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    if [ ${IS_NATIVE} == 'True' ]; then
        cp -rf /mingw64/lib/gdk-pixbuf-2.0 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    else
        cp -rf /usr/x86_64-w64-mingw32/sys-root/mingw/lib/gdk-pixbuf-2.0 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    fi
fi
