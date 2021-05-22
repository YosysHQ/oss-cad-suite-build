cd graphviz
patch -p1 < ${PATCHES_DIR}/graphviz_fix.diff
#if [ ${ARCH} == 'windows-x64' ]; then
#    echo $'\n#define GVDLL 1\n' >> config.h
#fi
./autogen.sh NOCONFIG
./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME} --build=`gcc -dumpmachine` --enable-shared=no --enable-static=yes --with-qt=no
pushd lib/gvpr && gcc mkdefs.c -o mkdefs && popd 
pushd lib/dotgen && make && popd
pushd lib/cdt && make && popd
pushd lib/xdot && make && popd
pushd lib/cgraph && make && popd
pushd lib/pathplan && make && popd
pushd lib/pack && make && popd
pushd lib/label && make && popd
pushd lib/common && make && popd
pushd lib/ortho && make && popd
pushd lib/gvc && make && popd

pushd plugin/core && make && popd
pushd lib/neatogen && make && popd
pushd lib/twopigen && make && popd
pushd lib/patchwork && make && popd
pushd lib/osage && make && popd
pushd lib/fdpgen && make && popd
pushd lib/sparse && make && popd
pushd lib/rbtree && make && popd
pushd lib/circogen && make && popd
pushd lib/sfdpgen && make && popd
pushd lib/vpsc && make && popd
pushd plugin/neato_layout && make && popd
pushd plugin/dot_layout && make && popd
pushd plugin/pango && make && popd
pushd cmd/dot && make dot_static${EXE} && popd

mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/bin
cp cmd/dot/dot_static${EXE} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/dot${EXE}

