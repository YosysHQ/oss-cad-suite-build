cd yosys
if [ ${ARCH} == 'linux-x64' ]; then
	echo 'set(CMAKE_C_COMPILER clang CACHE STRING "")' >> Configuration.cmake
	echo 'set(CMAKE_CXX_COMPILER clang++ CACHE STRING "")' >> Configuration.cmake
else
	touch Configuration.cmake
fi
if [ ${ARCH_BASE} == 'darwin' ]; then
sed -i '/auto allEdgeLists() const { return map | std::views::values | std::views::join;/c\
    auto allEdgeLists() const {\
        SmallVector<EdgeList> out;\
        for (const auto& [_, vec] : map)\
            for (const auto& e : vec)\
                out.push_back(e);\
        return out;\
    }
' libs/slang/source/analysis/ConstraintAnalysis.h 
fi
cmake -C Configuration.cmake -B build . \
	-DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
	-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
	-DCMAKE_BUILD_TYPE=Release
cmake --build build -j${NPROC}
DESTDIR=${OUTPUT_DIR} cmake --install build	--strip

pushd ${OUTPUT_DIR}${INSTALL_PREFIX} 
if [ ${ARCH} != 'windows-x64' ]; then
	mkdir -p lib
	ln -s ../bin/yosys-abc lib/
fi
popd
