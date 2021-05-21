cd graphviz
patch -p1 < ${PATCHES_DIR}/graphviz_fix.diff
pushd lib/gvpr
gcc mkdefs.c -o mkdefs
popd 
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
    -Denable_ltdl=OFF -Dwith_digcola=OFF -Dwith_ortho=OFF -Dwith_sfdp=OFF -Dwith_smyrna=OFF \
    .
if [ ${ARCH} == 'windows-x64' ]; then
    echo $'\n#define GVDLL 1\n' >> config.h
fi
make DESTDIR=${OUTPUT_DIR} install
