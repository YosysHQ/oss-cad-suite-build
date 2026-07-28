mv ${BUILD_DIR}/picosat/dev/* ${BUILD_DIR}/picosat
cd aiger
$CC -O3 -DNDEBUG -c aiger.c
cd ../lingeling
sed -i 's/-Wall/-Wall -Wno-incompatible-pointer-types/g' configure.sh
./configure.sh
make
cd ../aiger
sed -i 's,/@CC@/$CC/,|@CC@|$CC|,g' configure.sh 
sed -i 's,/usr/local,${OUTPUT_DIR}${INSTALL_PREFIX},g' makefile.in 
sed -i 's,755 -s,755,g' makefile.in 
./configure.sh
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/bin
make install
${STRIP} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/*
