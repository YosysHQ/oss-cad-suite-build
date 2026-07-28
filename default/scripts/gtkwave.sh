cd gtkwave

if [ ${ARCH} == 'darwin-x64' ]; then
    git checkout lts
    cd gtkwave3-gtk3
    cp LICENSE.TXT ..
    sed -i -re "s,@GSETTINGS_RULES@,,g" ./src/Makefile.am
    ./autogen.sh
    ./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME} --enable-gtk3 --with-tcl=$(xcrun --show-sdk-path)/System/Library/Frameworks/Tcl.framework --with-tk=$(xcrun --show-sdk-path)/System/Library/Frameworks/Tk.framework --disable-dependency-tracking
    make DESTDIR=${OUTPUT_DIR} UPDATE_DESKTOP_DATABASE=/bin/true -j${NPROC} install
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/share/gtkwave 
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/share/gtkwave-gtk3 
    exit 0
fi

if [ ${ARCH} != 'linux-x64' ]; then
    case ${ARCH} in
        linux-arm64)  SYSTEM=linux;   CPU=aarch64 ;;
        darwin-x64)   SYSTEM=darwin;  CPU=x86_64 ;;
        darwin-arm64) SYSTEM=darwin;  CPU=aarch64 ;;
        windows-x64)  SYSTEM=windows; CPU=x86_64 ;;
    esac
    cat > cross.ini <<CROSS_EOF
[binaries]
c = '${CC}'
cpp = '${CXX}'
ar = '${AR}'
strip = '${STRIP}'
pkgconfig = 'pkg-config'

[host_machine]
system = '${SYSTEM}'
cpu_family = '${CPU}'
cpu = '${CPU}'
endian = 'little'
CROSS_EOF
    CROSS_ARG="--cross-file cross.ini"
fi

meson setup builddir --prefix=${INSTALL_PREFIX} --libdir=lib -Dupdate_mime_database=false -Dintrospection=false -Dtests=false -Dset_rpath=disabled ${CROSS_ARG}
ninja -C builddir -j${NPROC}
DESTDIR=${OUTPUT_DIR} ninja -C builddir install
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/pkgconfig
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/include
