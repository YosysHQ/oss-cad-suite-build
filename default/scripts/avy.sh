cd avy
patch -p1 < ${PATCHES_DIR}/avy.diff
mkdir -p build
cd build
if [ ${ARCH_BASE} == 'windows' ]; then
    sed -i -re "s,m dl pthread z,m pthread z,g" ../avy/src/CMakeLists.txt
    cmake .. -DCMAKE_BUILD_TYPE=Release -D CMAKE_CXX_FLAGS="-DABC_USE_STDINT_H -DWIN32_NO_DLL -DHAVE_STRUCT_TIMESPEC -fpermissive -w"
else
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
fi
 
make -j${NPROC}
mkdir -p ${OUTPUT_DIR}/${INSTALL_PREFIX}/bin
${STRIP} avy/src/{avy${EXE},avybmc${EXE}}
cp avy/src/{avy${EXE},avybmc${EXE}} "${OUTPUT_DIR}${INSTALL_PREFIX}/bin/"