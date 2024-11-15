cd yosys-slang-plugin
sed -i 's/Windows.h/windows.h/g' third_party/slang/source/util/OS.cpp
sed -i 's,/yosyshq/share,../yosys/yosyshq/share,g' ../yosys/yosyshq/bin/yosys-config
sed -i 's,/yosyshq/include,../yosys/yosyshq/share/yosys/include,g' ../yosys/yosyshq/bin/yosys-config
sed -i 's,/yosyshq/lib,../yosys/yosyshq/lib,g' ../yosys/yosyshq/bin/yosys-config
make YOSYS_CONFIG=../yosys/yosyshq/bin/yosys-config
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/share/yosys/plugins
cp -rf build/slang.so ${OUTPUT_DIR}${INSTALL_PREFIX}/share/yosys/plugins/.
