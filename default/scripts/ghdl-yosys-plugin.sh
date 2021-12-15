cd ghdl-yosys-plugin
sed -i 's,/yosyshq/share,/yosys/yosyshq/share,g' ../yosys/yosyshq/bin/yosys-config
make GHDL=../ghdl/yosyshq/bin/ghdl YOSYS_CONFIG=../yosys/yosyshq/bin/yosys-config CFLAGS="-I ../yosys/yosyshq/share/yosys/include"
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/share/yosys/plugins
cp -rf ghdl.so ${OUTPUT_DIR}${INSTALL_PREFIX}/share/yosys/plugins/.