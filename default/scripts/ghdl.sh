cd ghdl
if [ ${ARCH_BASE} == 'darwin' ]; then
    export PATH="$PATH:/opt/gnat/bin"
    export GNAT_LARGS="-static-libgcc"
elif [ ${ARCH_BASE} == 'windows' ]; then
    if [ ${IS_NATIVE} != 'True' ]; then
        echo "GHDL not possible for Windows cross-compile for now."
        exit
    fi
fi
./configure --prefix=${INSTALL_PREFIX}
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
