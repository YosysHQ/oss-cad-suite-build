cd surelog
export HOME=/tmp
curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | python3
export PATH=/tmp/.local/bin:/usr/local/jre-11/bin:${BUILD_DIR}/capnproto/usr/local/bin:${BUILD_DIR}/flatbuffers/usr/local/bin:$PATH
pip install orderedmultidict
sed -i 's,COMMAND \${CAPNP_DIR}/capnp compile -o${CAPNP_DIR}/capnpc-c++,COMMAND capnp compile -oc++,g' third_party/UHDM/CMakeLists.txt
sed -i 's,\${FLATBUFFERS_FLATC_EXECUTABLE},flatc,g' CMakeLists.txt
if [ ${ARCH} != 'linux-x64' ]; then
    sed -i 's,\$<TARGET_FILE:surelog-bin>,echo,g' CMakeLists.txt
    mkdir -p bin/pkg
fi

sed -i 's,defined(_MSC_VER),defined(__MINGW32__),g'  src/Common/FileSystem.cpp 
sed -i 's,<Windows.h>,<windows.h>,g' src/Common/FileSystem.cpp 
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
mv ${OUTPUT_DIR}${INSTALL_PREFIX} ${OUTPUT_DIR}/dev
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/bin
rm -rf ${OUTPUT_DIR}/dev/bin/pkg
cp -r ${OUTPUT_DIR}/dev/bin/* ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.
