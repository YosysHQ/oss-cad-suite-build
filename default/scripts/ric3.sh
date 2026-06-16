cd ric3

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

cargo install --no-track --path . --root ${OUTPUT_DIR}${INSTALL_PREFIX} --target=${CARGO_TARGET}
