cd graphviz
pushd lib/gvpr
gcc mkdefs.c -o mkdefs
popd 
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
    -Denable_ltdl=OFF -Dwith_digcola=OFF -Dwith_ortho=OFF -Dwith_sfdp=OFF -Dwith_smyrna=OFF \
    .
#echo $'\n#define GVDLL 1\n#define  HAVE_DRAND48 1' >> config.h
make DESTDIR=${OUTPUT_DIR} install
