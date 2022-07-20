mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/
if [ ${ARCH} == 'windows-x64' ]; then
	cd iceprogduino/windows/winiceprogduino
	sed -i 's,usleep,usleep2,g' main.c
	${CC} main.c -o iceprogduino.exe
else
	cd iceprogduino/programmer/iceprogduino
	${CC} iceprogduino.c -o iceprogduino
fi
cp iceprogduino${EXE} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.
