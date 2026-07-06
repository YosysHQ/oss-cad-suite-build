cd yosys-slang-plugin
sed -i 's/Windows.h/windows.h/g' third_party/slang/source/util/OS.cpp
sed -i 's,/yosyshq/share,${BUILD_DIR}/yosys/yosyshq/share,g' ../yosys/yosyshq/bin/yosys-config
sed -i 's,/yosyshq/include,${BUILD_DIR}/yosys/yosyshq/share/yosys/include,g' ../yosys/yosyshq/bin/yosys-config
sed -i 's,/yosyshq/lib,${BUILD_DIR}/yosys/yosyshq/lib,g' ../yosys/yosyshq/bin/yosys-config
if [ ${ARCH_BASE} == 'darwin' ]; then
sed -i '/auto allEdgeLists() const { return map | std::views::values | std::views::join;/c\
    auto allEdgeLists() const {\
        SmallVector<EdgeList> out;\
        for (const auto& [_, vec] : map)\
            for (const auto& e : vec)\
                out.push_back(e);\
        return out;\
    }
' third_party/slang/source/analysis/ConstraintAnalysis.h 
fi
cmake -B build . -DCMAKE_BUILD_TYPE=Release -DYOSYS_CONFIG=../yosys/yosyshq/bin/yosys-config 
make -C build -j$(nproc)
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/share/yosys/plugins
cp -rf build/slang.so ${OUTPUT_DIR}${INSTALL_PREFIX}/share/yosys/plugins/.
