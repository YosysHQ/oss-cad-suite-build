cd gtkwave
if [ ${ARCH_BASE} == 'darwin' ]; then
    ./configure --prefix=${INSTALL_PREFIX} --with-tcl=$(xcrun --show-sdk-path)/System/Library/Frameworks/Tcl.framework --with-tk=$(xcrun --show-sdk-path)/System/Library/Frameworks/Tk.Framework
else
    ./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME}
fi
make DESTDIR=${OUTPUT_DIR} UPDATE_DESKTOP_DATABASE=/bin/true -j${NPROC} install
