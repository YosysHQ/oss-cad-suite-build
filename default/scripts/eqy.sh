sed -i 's,/yosyshq/share,../yosys/yosyshq/share,g' yosys/yosyshq/bin/yosys-config
sed -i 's,/yosyshq/include,../yosys/yosyshq/include,g' yosys/yosyshq/bin/yosys-config
sed -i 's,/yosyshq/lib,../yosys/yosyshq/lib,g' yosys/yosyshq/bin/yosys-config

cd eqy
export PATH=../yosys/yosyshq/bin:$PATH
make PREFIX=${OUTPUT_DIR}${INSTALL_PREFIX} -j${NPROC} install
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/eqy
cp -r examples/* ${OUTPUT_DIR}${INSTALL_PREFIX}/examples/eqy/.
