cd yosys-slang-plugin
sed -i 's/Windows.h/windows.h/g' third_party/slang/source/util/OS.cpp
sed -i 's,/yosyshq/share,${BUILD_DIR}/yosys/yosyshq/share,g' ../yosys/yosyshq/bin/yosys-config
sed -i 's,/yosyshq/include,${BUILD_DIR}/yosys/yosyshq/share/yosys/include,g' ../yosys/yosyshq/bin/yosys-config
sed -i 's,/yosyshq/lib,${BUILD_DIR}/yosys/yosyshq/lib,g' ../yosys/yosyshq/bin/yosys-config
make YOSYS_PREFIX=../yosys/yosyshq/bin/ -j${NPROC}
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/share/yosys/plugins
cp -rf build/slang.so ${OUTPUT_DIR}${INSTALL_PREFIX}/share/yosys/plugins/.
