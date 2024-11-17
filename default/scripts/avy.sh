cd avy
patch -p1 < ${PATCHES_DIR}/avy.diff
mkdir -p build
cd build
if [ ${ARCH_BASE} == 'windows' ]; then
    cmake .. -DCMAKE_BUILD_TYPE=Release -D CMAKE_CXX_FLAGS="-DABC_USE_STDINT_H -DWIN32_NO_DLL -DHAVE_STRUCT_TIMESPEC -fpermissive -w" -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
elif [ ${ARCH_BASE} == 'darwin' ]; then
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -D CMAKE_CXX_FLAGS="-Wno-register -Wno-deprecated"
else
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
fi
 
make -j${NPROC}
mkdir -p ${OUTPUT_DIR}/${INSTALL_PREFIX}/bin
${STRIP} avy/src/{avy${EXE},avybmc${EXE}}
cp avy/src/{avy${EXE},avybmc${EXE}} "${OUTPUT_DIR}${INSTALL_PREFIX}/bin/"