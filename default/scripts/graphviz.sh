cd graphviz
patch -p1 < ${PATCHES_DIR}/graphviz_fix.diff
pushd lib/gvpr
gcc mkdefs.c -o mkdefs
popd 
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
    -Denable_ltdl=OFF -Dwith_digcola=OFF -Dwith_ortho=OFF -Dwith_sfdp=OFF -Dwith_smyrna=OFF \
    .
if [ ${ARCH} == 'windows-x64' ]; then
    echo $'\n#define GVDLL 1\n' >> config.h
fi
make DESTDIR=${OUTPUT_DIR} -j${NPROC}
make DESTDIR=${OUTPUT_DIR} install
find ${OUTPUT_DIR}${INSTALL_PREFIX}/bin  -type l -delete
find ${OUTPUT_DIR}${INSTALL_PREFIX}/bin  -type f ! -name 'dot' -delete
if [ ${ARCH_BASE} == 'darwin' ]; then
    install_name_tool -id ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libcdt.5.0.0.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libcdt.5.0.0.dylib 
    install_name_tool -id ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libcgraph.6.0.0.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libcgraph.6.0.0.dylib
    install_name_tool -id ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libgvc.6.0.0.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libgvc.6.0.0.dylib
    install_name_tool -id ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libpathplan.4.0.0.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libpathplan.4.0.0.dylib
    install_name_tool -id ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libxdot.4.0.0.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libxdot.4.0.0.dylib 

    install_name_tool -change libcdt.5.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libcdt.5.0.0.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/dot
    install_name_tool -change libcgraph.6.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libcgraph.6.0.0.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/dot
    install_name_tool -change libgvc.6.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libgvc.6.0.0.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/dot
    install_name_tool -change libpathplan.4.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libpathplan.4.0.0.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/dot
    install_name_tool -change libxdot.4.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libxdot.4.0.0.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/dot


    install_name_tool -change libcdt.5.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libcdt.5.0.0.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libcgraph.6.0.0.dylib

    install_name_tool -change libcgraph.6.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libcgraph.6.0.0.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libgvc.6.0.0.dylib
    install_name_tool -change libpathplan.4.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libpathplan.4.0.0.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libgvc.6.0.0.dylib
    install_name_tool -change libxdot.4.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libxdot.4.0.0.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libgvc.6.0.0.dylib
    install_name_tool -change libcdt.5.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libcdt.5.0.0.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libgvc.6.0.0.dylib

    install_name_tool -id ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/graphviz/libgvplugin_core.6.0.0.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/graphviz/libgvplugin_core.6.0.0.dylib
    install_name_tool -id ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/graphviz/libgvplugin_dot_layout.6.0.0.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/graphviz/libgvplugin_dot_layout.6.0.0.dylib
    install_name_tool -id ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/graphviz/libgvplugin_neato_layout.6.0.0.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/graphviz/libgvplugin_neato_layout.6.0.0.dylib
    install_name_tool -id ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/graphviz/libgvplugin_pango.6.0.0.dylib  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/graphviz/libgvplugin_pango.6.0.0.dylib
fi
