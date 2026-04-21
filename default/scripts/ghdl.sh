cd ghdl
param=--with-llvm-config="llvm-config"
GHDL_NIGHTLY_API="https://api.github.com/repos/ghdl/ghdl/releases/tags/nightly"

get_release_asset_name() {
    local pattern="$1"
    printf '%s\n' "${GHDL_RELEASE_JSON}" \
        | grep -o '"name": "[^"]*"' \
        | cut -d '"' -f 4 \
        | grep -E "${pattern}" \
        | head -n1
}

configure_darwin_ghdl_libs() {
    local lib_dir="$1"
    local libghdl
    local libghdlvpi
    local libgnat
    local libgcc

    libghdl=$(ls "${lib_dir}"/libghdl-*.dylib 2>/dev/null | head -n1)
    libghdlvpi=$(ls "${lib_dir}"/libghdlvpi*.dylib 2>/dev/null | head -n1)
    libgnat=$(ls "${lib_dir}"/libgnat-*.dylib 2>/dev/null | head -n1)
    libgcc=$(ls "${lib_dir}"/libgcc_s*.dylib 2>/dev/null | head -n1)

    if [ -z "${libghdl}" ] || [ -z "${libghdlvpi}" ] || [ -z "${libgnat}" ] || [ -z "${libgcc}" ]; then
        echo "Failed to locate required Darwin GHDL libraries in ${lib_dir}" >&2
        exit 1
    fi

    install_name_tool -id "@executable_path/../lib/$(basename "${libghdl}")" "${libghdl}"
    install_name_tool -id "@executable_path/../lib/$(basename "${libghdlvpi}")" "${libghdlvpi}"
    install_name_tool -id "@executable_path/../lib/$(basename "${libgnat}")" "${libgnat}"
    install_name_tool -id "@executable_path/../lib/$(basename "${libgcc}")" "${libgcc}"
    install_name_tool -change "@rpath/$(basename "${libgnat}")" "@executable_path/../lib/$(basename "${libgnat}")" "${libghdl}"
    install_name_tool -change "@rpath/$(basename "${libgcc}")" "@executable_path/../lib/$(basename "${libgcc}")" "${libghdl}"
    install_name_tool -change "@rpath/$(basename "${libgcc}")" "@executable_path/../lib/$(basename "${libgcc}")" "${libgnat}"

    rcodesign sign "${libghdl}"
    rcodesign sign "${libghdlvpi}"
    rcodesign sign "${libgnat}"
    rcodesign sign "${libgcc}"
}

sed -i 's,ghdl1-llvm,../bin/ghdl1-llvm,g' configure
if [ ${ARCH} == 'linux-arm64' ]; then
    sed -i 's,grt-all libs.vhdl.llvm all.vpi,grt-all all.vpi,g' Makefile.in
    sed -i 's,install.llvm.program install.vhdllib,install.llvm.program ,g' Makefile.in
    sed -i '130,133d' Makefile.in
    export GNATMAKE=${CROSS_NAME}-gnatmake
    param=--with-llvm-config='llvm-config'
    LDFLAGS=-L/usr/lib/${CROSS_NAME}
elif [ ${ARCH} == 'darwin-x64' ]; then
    GHDL_RELEASE_JSON=$(curl -fsSL "${GHDL_NIGHTLY_API}")
    GHDL_DARWIN_ASSET=$(get_release_asset_name '^ghdl-llvm-.*-macos[0-9]+-x86_64\.tar\.gz$')
    if [ -z "${GHDL_DARWIN_ASSET}" ]; then
        echo "No darwin-x64 LLVM artifact found in GHDL nightly release" >&2
        exit 1
    fi
    wget "https://github.com/ghdl/ghdl/releases/download/nightly/${GHDL_DARWIN_ASSET}"
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}
    tar xvfz "${GHDL_DARWIN_ASSET}" -C ${OUTPUT_DIR}${INSTALL_PREFIX} --strip-components=1
    configure_darwin_ghdl_libs "${OUTPUT_DIR}${INSTALL_PREFIX}/lib"
    exit 0
elif [ ${ARCH} == 'darwin-arm64' ]; then
    GHDL_RELEASE_JSON=$(curl -fsSL "${GHDL_NIGHTLY_API}")
    GHDL_DARWIN_ASSET=$(get_release_asset_name '^ghdl-llvm-.*-macos14-aarch64\.tar\.gz$')
    if [ -z "${GHDL_DARWIN_ASSET}" ]; then
        GHDL_DARWIN_ASSET=$(get_release_asset_name '^ghdl-llvm-.*-macos[0-9]+-aarch64\.tar\.gz$')
    fi
    if [ -z "${GHDL_DARWIN_ASSET}" ]; then
        echo "No darwin-arm64 LLVM artifact found in GHDL nightly release" >&2
        exit 1
    fi
    wget "https://github.com/ghdl/ghdl/releases/download/nightly/${GHDL_DARWIN_ASSET}"
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}
    tar xvfz "${GHDL_DARWIN_ASSET}" -C ${OUTPUT_DIR}${INSTALL_PREFIX} --strip-components=1
    configure_darwin_ghdl_libs "${OUTPUT_DIR}${INSTALL_PREFIX}/lib"
    exit 0
elif [ ${ARCH} == 'windows-x64' ]; then
    sed -i 's,grt-all libs.vhdl.llvm all.vpi,grt-all all.vpi,g' Makefile.in
    sed -i 's,install.llvm.program install.vhdllib,install.llvm.program ,g' Makefile.in
    sed -i '130,133d' Makefile.in
    export GNATMAKE=${CROSS_NAME}-gnatmake
    sed -i 's,$(LDFLAGS) `$(LLVM_LDFLAGS)`,`$(LLVM_LDFLAGS)` $(LDFLAGS),g' src/ortho/llvm6/Makefile
    param=--with-llvm-config="/usr/x86_64-w64-mingw32/bin/llvm-config"
    LDFLAGS="-luuid -lole32 -lz -lssp"
fi
./configure --prefix=${INSTALL_PREFIX} \
        --enable-checks \
        --enable-libghdl \
        --enable-synth \
        ${param} LDFLAGS="${LDFLAGS}"

make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install

