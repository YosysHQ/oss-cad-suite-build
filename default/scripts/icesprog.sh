cd icesprog/tools/src
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/
if [ ${ARCH} == 'windows-x64' ] || [ ${ARCH_BASE} == 'darwin' ]; then
      sed -i 's,HIDAPI = hidapi-hidraw,HIDAPI = hidapi,g' Makefile
fi
make
cp icesprog${EXE} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.
