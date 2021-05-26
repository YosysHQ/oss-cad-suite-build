cd cvc4
export MACHINE_TYPE=x86_64
if [ ${ARCH_BASE} != 'windows' ]; then
    sed -i -re 's,rm -rf src/antlr3debughandlers.c \&\& touch src/antlr3debughandlers.c,rm -rf src/antlr3debughandlers.c \&\& touch src/antlr3debughandlers.c \&\& cp  /usr/share/misc/config.* . ,g' ./contrib/get-antlr-3.4
fi
ANTLR_CONFIGURE_ARGS="--host=${CROSS_NAME} --build=`gcc -dumpmachine`"  ./contrib/get-antlr-3.4
git clone https://github.com/uiri/toml.git
export PYTHONPATH=$PYTHONPATH:`pwd`/toml
if [ ${ARCH_BASE} == 'windows' ]; then
    export CMAKE_TOOLCHAIN_FILE=${PATCHES_DIR}/Toolchain-mingw64.cmake
    sed -i -re 's,cmake \"\$root_dir\" \$cmake_opts,cmake \"\$root_dir\" \$cmake_opts -DCMAKE_TOOLCHAIN_FILE=\$\{CMAKE_TOOLCHAIN_FILE\} -DCVC4_WINDOWS_BUILD=TRUE,g' configure.sh
else
    sed -i -re 's,cmake \"\$root_dir\" \$cmake_opts,cmake \"\$root_dir\" \$cmake_opts -DCMAKE_TOOLCHAIN_FILE=\$\{CMAKE_TOOLCHAIN_FILE\},g' configure.sh
fi
CXXFLAGS=-fPIC CFLAGS=-fPIC ./configure.sh --static --no-static-binary --prefix=${INSTALL_PREFIX} --no-unit-testing
cd build
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} install
cd ..
mkdir -p ${OUTPUT_DIR}/dev
mkdir -p ${OUTPUT_DIR}/dev/build
cp -r src ${OUTPUT_DIR}/dev/.
cp -r build/src ${OUTPUT_DIR}/dev/build/.
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/include
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
