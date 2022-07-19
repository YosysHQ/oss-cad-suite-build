mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/
if [ ${ARCH} == 'windows-x64' ]; then
	cp iceprogduino/windows/winiceprogduino/winiceprogduino.exe ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/iceprogduino.exe
else
	cd iceprogduino/programmer/iceprogduino
	make
	cp iceprogduino${EXE} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.
fi
