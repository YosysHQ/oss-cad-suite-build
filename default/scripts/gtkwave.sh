cd gtkwave

# Setup meson and ninja (not available in Docker image)
if ! command -v meson &>/dev/null; then
    wget -q https://github.com/ninja-build/ninja/releases/download/v1.12.1/ninja-linux.zip -O /tmp/ninja.zip
    python3 -c "import zipfile; zipfile.ZipFile('/tmp/ninja.zip').extractall('/tmp/meson-tools')"
    chmod +x /tmp/meson-tools/ninja
    wget -q https://github.com/mesonbuild/meson/releases/download/1.7.0/meson-1.7.0.tar.gz -O /tmp/meson.tar.gz
    tar xf /tmp/meson.tar.gz -C /tmp/meson-tools
    printf '#!/bin/sh\nexec python3 /tmp/meson-tools/meson-1.7.0/meson.py "$@"\n' > /tmp/meson-tools/meson
    chmod +x /tmp/meson-tools/meson
    export PATH=/tmp/meson-tools:$PATH
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

meson setup builddir --prefix=${INSTALL_PREFIX} --libdir=lib -Dupdate_mime_database=false -Dintrospection=false -Dset_rpath=disabled ${CROSS_ARG}
ninja -C builddir -j${NPROC}
DESTDIR=${OUTPUT_DIR} ninja -C builddir install
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/share/gtkwave
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/share/gtkwave3
