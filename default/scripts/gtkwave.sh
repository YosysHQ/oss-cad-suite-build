cd gtkwave
if [ ${ARCH_BASE} == 'darwin' ]; then
    ./configure --prefix=${INSTALL_PREFIX} --with-tcl=$(xcrun --show-sdk-path)/System/Library/Frameworks/Tcl.framework --with-tk=$(xcrun --show-sdk-path)/System/Library/Frameworks/Tk.Framework
elif [ ${ARCH_BASE} == 'windows' ]; then
    ./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME} MINGW_LDADD="-lcomdlg32" --with-tcl=/usr/x86_64-w64-mingw32/sys-root/mingw/lib --with-tk=/usr/x86_64-w64-mingw32/sys-root/mingw/lib
else
    ./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME}
fi
make DESTDIR=${OUTPUT_DIR} UPDATE_DESKTOP_DATABASE=/bin/true -j${NPROC} install
