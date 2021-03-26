cd suprove
patch -p1 < ${PATCHES_DIR}/suprove.diff
mkdir -p build
if [ ${ARCH} == 'linux-arm64' ] || [ ${ARCH} == 'linux-riscv64' ]; then
      sed -i -re 's,ARCHFLAGS_EXE=\$\{CMAKE_CURRENT_BINARY_DIR\}/abc_arch_flags_program.exe,ARCHFLAGS=\"-DLIN64 -DSIZEOF_VOID_P=8 -DSIZEOF_LONG=8 -DSIZEOF_INT=4\",g' abc/CMakeLists.txt
elif [ ${ARCH} == 'linux-arm' ]; then
      sed -i -re 's,ARCHFLAGS_EXE=\$\{CMAKE_CURRENT_BINARY_DIR\}/abc_arch_flags_program.exe,ARCHFLAGS=\"-DLIN -DSIZEOF_VOID_P=4 -DSIZEOF_LONG=4 -DSIZEOF_INT=4\",g' abc/CMakeLists.txt
fi
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR}${INSTALL_PREFIX}/super_prove \
      -DPYTHON_INCLUDE_DIR=${BUILD_DIR}/python2${INSTALL_PREFIX}/include/python2.7 \
      -DPYTHON_LIBRARY=${BUILD_DIR}/python2${INSTALL_PREFIX}/lib/libpython2.7${SHARED_EXT}
      ..
make -j${NPROC}
make -j${NPROC} install
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/bin
cat > ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/suprove <<EOT
#!/usr/bin/env bash
tool=super_prove; if [ "\$1" != "\${1#+}" ]; then tool="\${1#+}"; shift; fi
export PYTHONNOUSERSITE=1
export PYTHONPATH=\$(dirname \${BASH_SOURCE[0]})/../lib/python2.7:\$(dirname \${BASH_SOURCE[0]})/../lib/python2.7/site-packages
exec \$(dirname \${BASH_SOURCE[0]})/../super_prove/bin/\${tool}.sh "\$@"
EOT
chmod +x ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/suprove
