cd smt-switch
MACHINE_TYPE=x86_64 ./contrib/setup-cvc4.sh
./contrib/setup-btor.sh
./configure.sh --btor --cvc4 --prefix=${INSTALL_PREFIX} --static
cd build
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} install
cd ..
cp -R cmake ${OUTPUT_DIR}${INSTALL_PREFIX}/.
