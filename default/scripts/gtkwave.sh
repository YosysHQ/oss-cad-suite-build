if [ ${ARCH_BASE} == 'darwin' ]; then
    cd gtkwave/gtkwave3
    ./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME} --with-tcl=$(xcrun --show-sdk-path)/System/Library/Frameworks/Tcl.framework --with-tk=$(xcrun --show-sdk-path)/System/Library/Frameworks/Tk.framework
elif [ ${ARCH_BASE} == 'windows' ]; then
    cd gtkwave/gtkwave3-gtk3
    ./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME} --enable-gtk3 MINGW_LDADD="-lcomdlg32" --with-tcl=/usr/x86_64-w64-mingw32/sys-root/mingw/lib --with-tk=/usr/x86_64-w64-mingw32/sys-root/mingw/lib
else
    cd gtkwave/gtkwave3-gtk3
    ./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME} --enable-gtk3
fi
make DESTDIR=${OUTPUT_DIR} UPDATE_DESKTOP_DATABASE=/bin/true -j${NPROC} install
