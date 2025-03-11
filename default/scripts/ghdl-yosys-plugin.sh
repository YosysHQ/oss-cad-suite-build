cd ghdl-yosys-plugin
sed -i 's,/yosyshq/share,/yosys/yosyshq/share,g' ../yosys/yosyshq/bin/yosys-config
if [ ${ARCH} == 'darwin-x64' ] || [ ${ARCH} == 'darwin-arm64' ]; then
    sed -i '11,13d' Makefile
    make GHDL=../ghdl/yosyshq/bin/ghdl YOSYS_CONFIG=../yosys/yosyshq/bin/yosys-config CFLAGS="-I ../yosys/yosyshq/share/yosys/include" LIBGHDL_LIB="${BUILD_DIR}/ghdl${INSTALL_PREFIX}/lib/libghdl-6_0_0_dev.dylib" LIBGHDL_INC="${BUILD_DIR}/ghdl${INSTALL_PREFIX}/include/"
else
    make GHDL=../ghdl/yosyshq/bin/ghdl YOSYS_CONFIG=../yosys/yosyshq/bin/yosys-config CFLAGS="-I ../yosys/yosyshq/share/yosys/include"
fi
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/share/yosys/plugins
cp -rf ghdl.so ${OUTPUT_DIR}${INSTALL_PREFIX}/share/yosys/plugins/.
