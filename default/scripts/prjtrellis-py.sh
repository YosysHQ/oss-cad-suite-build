cd prjtrellis
cd libtrellis
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -DBUILD_PYTHON=ON \
      .
make DESTDIR=${OUTPUT_DIR} -j${NPROC} pytrellis
cp pytrellis.so ${OUTPUT_DIR}/.
if [ ${ARCH} == 'linux-x64' ]; then
    cp /lib/x86_64-linux-gnu/libpython3.8.so.1.0 ${OUTPUT_DIR}/.
    cp /lib/x86_64-linux-gnu/libboost_thread.so.1.71.0 ${OUTPUT_DIR}/.
fi