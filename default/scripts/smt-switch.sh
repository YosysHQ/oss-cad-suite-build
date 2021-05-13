cd smt-switch
sed -i -re 's,target_link_libraries\(smt-switch-btor smt-switch\),target_link_libraries\(smt-switch-btor smt-switch\)\ntarget_link_libraries(smt-switch-btor \"\$\{BTOR_HOME\}/deps/lingeling/build/liblgl.a\"),g' btor/CMakeLists.txt
sed -i -re 's,cmake \"\$root_dir\" \$cmake_opts,cmake \"\$root_dir\" \$cmake_opts -DCMAKE_TOOLCHAIN_FILE=\$\{CMAKE_TOOLCHAIN_FILE\},g' configure.sh
./configure.sh --cvc4 --cvc4-home=${BUILD_DIR}/cvc4/dev --btor-home=${BUILD_DIR}/boolector/dev --prefix=${INSTALL_PREFIX} --static
cd build
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} install
cd ..
cp -R cmake ${OUTPUT_DIR}${INSTALL_PREFIX}/.
