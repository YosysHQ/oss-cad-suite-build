cd bitwuzla

# update GMP and MPFR
sed -i 's/>=6\.3/>=6.2/g' src/meson.build
sed -i 's/>=4\.2\.1/>=4.0/g' src/meson.build

arch_gen=
# Build Bitwuzla
if [ ${ARCH} == 'darwin-arm64' ]; then
    arch_gen=--arm64
    cat > x86_64-linux-aarch64.txt <<'EOF'
[binaries]
pkg-config = 'aarch64-apple-darwin23.5-pkg-config'

[host_machine]
system = 'darwin'
cpu_family = 'aarch64'
cpu = 'arm64'
endian = 'little'

[properties]
needs_exe_wrapper = true
EOF
fi

if [ ${ARCH} == 'darwin-x64' ]; then
    arch_gen=--arm64
    cat > x86_64-linux-aarch64.txt <<'EOF'
[binaries]
pkg-config = 'x86_64-apple-darwin23.5-pkg-config'

[host_machine]
system = 'darwin'
cpu_family = 'x86_64'
cpu = 'x86_64'
endian = 'little'

[properties]
needs_exe_wrapper = true
EOF
fi

if [ ${ARCH} == 'linux-arm64' ]; then
    arch_gen=--arm64
    cat > x86_64-linux-aarch64.txt <<'EOF'
[binaries]
pkg-config = 'aarch64-linux-gnu-pkg-config'

[host_machine]
system = 'linux'
cpu_family = 'aarch64'
cpu = 'arm64'
endian = 'little'

[properties]
needs_exe_wrapper = true
EOF
fi

if [ ${ARCH} == 'windows-x64' ]; then
    arch_gen=--win64
    cat > x86_64-w64-mingw32.txt <<'EOF'
[binaries]
pkg-config = 'x86_64-w64-mingw32-pkg-config'

[host_machine]
system = 'windows'
cpu_family = 'x86_64'
cpu = 'x86_64'
endian = 'little'

[properties]
needs_exe_wrapper = true
EOF
fi

./configure.py --prefix ${INSTALL_PREFIX} ${arch_gen}
DESTDIR="${OUTPUT_DIR}" ninja -C build install
# Do not expose includes and libs in final package
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/include
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
