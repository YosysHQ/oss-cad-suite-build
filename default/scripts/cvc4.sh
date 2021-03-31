cd cvc4
export MACHINE_TYPE=x86_64
if [ ${ARCH_BASE} != 'darwin' ]; then
    sed -i -re 's,rm -rf src/antlr3debughandlers.c \&\& touch src/antlr3debughandlers.c,rm -rf src/antlr3debughandlers.c \&\& touch src/antlr3debughandlers.c \&\& cp  /usr/share/misc/config.* . ,g' ./contrib/get-antlr-3.4
fi
ANTLR_CONFIGURE_ARGS="--host=${CROSS_NAME} --build=`gcc -dumpmachine`"  ./contrib/get-antlr-3.4
git clone https://github.com/uiri/toml.git
export PYTHONPATH=$PYTHONPATH:`pwd`/toml
sed -i -re 's,cmake \"$root_dir\" \$cmake_opts,cmake \"$root_dir\" \$cmake_opts -DCMAKE_TOOLCHAIN_FILE=\$\{CMAKE_TOOLCHAIN_FILE\},g' CMakeLists.txt 
CXXFLAGS=-fPIC CFLAGS=-fPIC ./configure.sh --static --no-static-binary --prefix=${INSTALL_PREFIX}
cd build
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} install
cd ..
mkdir -p ${OUTPUT_DIR}/dev
mkdir -p ${OUTPUT_DIR}/dev/build
cp -r src ${OUTPUT_DIR}/dev/.
cp -r build/src ${OUTPUT_DIR}/dev/build/.
