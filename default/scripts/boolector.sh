if [ ${ARCH_BASE} == 'windows' ]; then
    pushd lingeling
    git checkout 03b4860d14016f42213ea271014f2f13d181f504
    popd
    pushd cadical
    git checkout cb89cbfa16f47cb7bf1ec6ad9855e7b6d5203c18
    popd
fi
cd boolector
patch -p1 < ${PATCHES_DIR}/boolector.diff
sed -i -re "s,MINGW32,MINGW64,g" contrib/setup-utils.sh
sed -i -re "s,test_apply_patch,#test_apply_patch,g" contrib/setup-btor2tools.sh
bash contrib/setup-btor2tools.sh
bash contrib/setup-lingeling.sh
bash contrib/setup-cadical.sh
if [ ${ARCH_BASE} == 'windows' ]; then
    mkdir -p build
    cd build
    cmake .. -DPYTHON=OFF -DIS_WINDOWS_BUILD=1 -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX}
    cd ..
else
    ./configure.sh --prefix ${INSTALL_PREFIX}
fi
cd build
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
