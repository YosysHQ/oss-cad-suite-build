cd smt-switch
sed -i 's,\$DEPS/bison/bison-install,${OUTPUT_DIR}/deps/bison/bison-install,g' ./contrib/setup-bison.sh
./contrib/setup-bison.sh
