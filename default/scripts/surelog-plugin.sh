sed -i 's,/yosyshq/share,../../yosys/yosyshq/share,g' yosys/yosyshq/bin/yosys-config
sed -i 's,/yosyshq/include,../../yosys/yosyshq/include,g' yosys/yosyshq/bin/yosys-config
mkdir -p ${OUTPUT_DIR}/yosyshq/share/yosys/plugins
mkdir -p ${BUILD_DIR}/surelog/dev/lib64/uhdm
mkdir -p ${BUILD_DIR}/surelog/dev/lib64/surelog
cd surelog-plugin
sed -i 's,DATA_DIR = \$(DESTDIR)\$(shell \$(YOSYS_CONFIG) --datdir),DATA_DIR = ${OUTPUT_DIR}/yosyshq/share/yosys,g' Makefile_plugin.common
sed -i 's,PLUGINS_DIR = \$(DATA_DIR)/plugins,PLUGINS_DIR = ${OUTPUT_DIR}/yosyshq/share/yosys/plugins,g' Makefile_plugin.common
if [ ${ARCH_BASE} == 'darwin' ] ; then
    sed -i 's,-Wl\,--whole-archive -luhdm -Wl\,--no-whole-archive,-luhdm,g' systemverilog-plugin/Makefile
    sed -i 's,-lrt,,g' systemverilog-plugin/Makefile
    export MACOSX_DEPLOYMENT_TARGET=10.15
fi
make YOSYS_PATH=${BUILD_DIR}/yosys/yosyshq/ DESTDIR=${OUTPUT_DIR} -j${NPROC} PLUGIN_LIST="systemverilog" UHDM_INSTALL_DIR=${BUILD_DIR}/surelog/dev install