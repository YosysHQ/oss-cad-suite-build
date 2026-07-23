cd gtkwave/gtkwave3-gtk3
if [ ${ARCH_BASE} == 'darwin' ]; then
    sed -i -re "s,@GSETTINGS_RULES@,,g" ./src/Makefile.am
    ./autogen.sh
    ./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME} --enable-gtk3 --with-tcl=$(xcrun --show-sdk-path)/System/Library/Frameworks/Tcl.framework --with-tk=$(xcrun --show-sdk-path)/System/Library/Frameworks/Tk.framework --disable-dependency-tracking
elif [ ${ARCH_BASE} == 'windows' ]; then
    sed -i -re "s,@GSETTINGS_RULES@,,g" ./src/Makefile.am
    sed -i '55a\
#if defined(__MINGW32__)\
char *strndup(const char *s, size_t n)\
{\
    size_t len = strnlen(s, n);\
    char *p = (char *)malloc(len + 1);\
    if (!p)\
        return NULL;\
    memcpy(p, s, len);\
    p[len] = '\''\0'\'';\
    return p;\
}\
#endif\
' src/helpers/vcd2fst.c
    sed -i 's/extern int getopt ();/extern int getopt (int ___argc, char *const *___argv, const char *__shortopts);/' src/gnu-getopt.h
    ./autogen.sh
    ./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME} --enable-gtk3 MINGW_LDADD="-lcomdlg32" --with-tcl=/usr/x86_64-w64-mingw32/sys-root/mingw/lib --with-tk=/usr/x86_64-w64-mingw32/sys-root/mingw/lib
else
    ./autogen.sh
    ./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME} --enable-gtk3
fi
make DESTDIR=${OUTPUT_DIR} UPDATE_DESKTOP_DATABASE=/bin/true -j${NPROC} install
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/share/gtkwave 
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/share/gtkwave-gtk3 
