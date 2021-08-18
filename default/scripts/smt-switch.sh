cd smt-switch
sed -i -re 's,target_link_libraries\(smt-switch-btor smt-switch\),target_link_libraries\(smt-switch-btor smt-switch\)\ntarget_link_libraries(smt-switch-btor \"\$\{BTOR_HOME\}/deps/lingeling/build/liblgl.a\"),g' btor/CMakeLists.txt
sed -i -re 's,cmake \"\$root_dir\" \$cmake_opts,cmake \"\$root_dir\" \$cmake_opts -DCMAKE_TOOLCHAIN_FILE=\$\{CMAKE_TOOLCHAIN_FILE\},g' configure.sh
sed -i 's,add_subdirectory(tests),#add_subdirectory(tests),g' CMakeLists.txt 
if [ ${ARCH_BASE} == 'windows' ]; then
    patch -p1 < ${PATCHES_DIR}/smt-switch-win32.diff
    sed -i -re 's,__APPLE__,__WIN32__,g' src/generic_solver.cpp
    sed -i -re 's,__APPLE__,__WIN32__,g' tests/test-generic-solver.cpp
    sed -i -re 's,\*.o,\*.obj,g' cvc4/CMakeLists.txt
    sed -i -re 's,\*.o,\*.obj,g' btor/CMakeLists.txt
    echo > contrib/memstream-0.1/memstream.c
fi
./configure.sh --cvc4 --cvc4-home=${BUILD_DIR}/cvc4/dev --btor-home=${BUILD_DIR}/boolector/dev --prefix=${INSTALL_PREFIX} --static --smtlib-reader --bison-dir=${BUILD_DIR}/bison/deps/bison/bison-install
cd build
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} install
cd ..
cp -R cmake ${OUTPUT_DIR}${INSTALL_PREFIX}/.
