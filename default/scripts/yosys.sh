cd yosys
if [ ${ARCH} == 'linux-x64' ]; then
	echo 'set(CMAKE_C_COMPILER clang CACHE STRING "")' >> Configuration.cmake
	echo 'set(CMAKE_CXX_COMPILER clang++ CACHE STRING "")' >> Configuration.cmake
else
	touch Configuration.cmake
fi
cmake -C Configuration.cmake -B build . \
	-DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
	-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
	-DCMAKE_BUILD_TYPE=Release
cmake --build build -j${NPROC}
DESTDIR=${OUTPUT_DIR} cmake --install build	--strip

pushd ${OUTPUT_DIR}${INSTALL_PREFIX} 
if [ ${ARCH} != 'windows-x64' ]; then
	mkdir -p lib
	ln -s ../bin/yosys-abc lib/
fi
popd
