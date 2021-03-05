if [ ${IS_LOCAL} == 'True' ]; then
    exit
fi
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts ${OUTPUT_DIR}${INSTALL_PREFIX}/share/fonts
if [ ${ARCH_BASE} == 'linux' ]; then
    cp -r /usr/share/fonts/. ${OUTPUT_DIR}${INSTALL_PREFIX}/share/fonts
    cp -r /etc/fonts/.   ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts
    rm ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts/fonts.conf
    cp ${PATCHES_DIR}/setup.sh ${OUTPUT_DIR}${INSTALL_PREFIX}/.
    cp ${PATCHES_DIR}/fonts.conf.template ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts/.
fi
