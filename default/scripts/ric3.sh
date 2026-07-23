cd ric3
export RUSTUP_TOOLCHAIN=nightly-2026-01-01
sed -i 's/\.env("CXX", "clang++")/\/\/.env("CXX", "clang++")/g' deps/cadical-rs/build.rs
sed -i 's/Config::new(bindings)\.build();/Config::new(bindings).define("CMAKE_TRY_COMPILE_TARGET_TYPE", "STATIC_LIBRARY").build();/g' deps/cadical-rs/build.rs
sed -i 's/\.env("CC", "clang")/\/\/.env("CC", "clang")/g' deps/kissat-rs/build.rs 
pushd deps/cadical-rs/cadical
if [ ${ARCH_BASE} == 'windows' ]; then
    git checkout cb89cbfa16f47cb7bf1ec6ad9855e7b6d5203c18
    patch -p1 < ${PATCHES_DIR}/CaDiCaL_20190730.patch
fi
if [ ${ARCH} == 'linux-arm64' ]; then
    sed -i '332,536d' configure
fi
if [ ${ARCH_BASE} == 'darwin' ]; then
    sed -i '332,536d' configure
    sed -i 's/stdc++/c++/g' ../build.rs
fi
if [ ${ARCH_BASE} == 'windows' ]; then
    sed -i '247,347d' configure
    EXTRA_FLAGS="-q"
fi
sed -i 's/\[ \$closefrom = no \] && //g' configure
popd

pushd deps/bitwuzla-rs/bitwuzla

# update GMP and MPFR
sed -i 's/>=6\.3/>=6.2/g' src/meson.build
sed -i 's/>=4\.2\.1/>=4.0/g' src/meson.build

arch_gen=
# Build Bitwuzla
if [ ${ARCH} == 'darwin-arm64' ]; then
    rustup target add aarch64-apple-darwin
    arch_gen=--arm64
    cat > x86_64-linux-aarch64.txt <<'EOF'
[binaries]
pkg-config = 'aarch64-apple-darwin25.5-pkg-config'

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
    rustup target add x86_64-apple-darwin
    arch_gen=--arm64
    cat > x86_64-linux-aarch64.txt <<'EOF'
[binaries]
pkg-config = 'x86_64-apple-darwin25.5-pkg-config'

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
    rustup target add aarch64-unknown-linux-gnu
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

if [ ${ARCH} != 'linux-x64' ]; then
    sed -i 's/\.arg("configure\.py")/\.arg("configure.py").arg("--arm64")/g' ../build.rs
fi
if [ ${ARCH_BASE} == 'darwin' ]; then
    sed -i 's/stdc++/c++/g' ../build.rs
fi
if [ ${ARCH} == 'linux-arm64' ]; then
    sed -i 's/\*const i8/\*const std::ffi::c_char/g' ../src/lib.rs
fi
popd

sed -i -E 's|Command::new\(current_exe\(\)\.unwrap\(\)\)|Command::new(std::env::var("RIC3_EXE").map(std::path::PathBuf::from).unwrap_or_else(\|_\| std::env::current_exe().unwrap()))|g' src/portfolio/mod.rs

cargo install --no-track --path . --root ${OUTPUT_DIR}${INSTALL_PREFIX} --target=${CARGO_TARGET}
