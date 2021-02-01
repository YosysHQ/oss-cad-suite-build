cd boolector
patch -p1 < ${PATCHES_DIR}/boolector.diff
bash contrib/setup-btor2tools.sh
bash contrib/setup-lingeling.sh
bash contrib/setup-cadical.sh
./configure.sh --prefix ${INSTALL_PREFIX}
cd build
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
