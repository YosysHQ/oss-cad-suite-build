cd icestorm
sed -i 's,Darwin,XXXXX,g' icebox/Makefile
sed -i 's,CC,CXX,g' iceprog/Makefile
make PREFIX=${INSTALL_PREFIX} DESTDIR=${OUTPUT_DIR} install -j${NPROC}
if [ ${ARCH_BASE} != 'windows' ]; then
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec
    mv ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/icebox.py ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec/.
    mv ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/iceboxdb.py ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec/.
    for f in $(find ${OUTPUT_DIR}${INSTALL_PREFIX}/bin -type l)
    do
        cp --remove-destination $(readlink -e $f) $f
    done
else
    sed 's|#!/usr/bin/env python3|#|g' -i  ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/icebox.py
fi
