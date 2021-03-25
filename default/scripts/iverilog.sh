cd iverilog
sed -i "s/\$(CC) \$(CFLAGS) -o draw_tt/gcc \$(CFLAGS) -o draw_tt/g" vvp/Makefile.in
sh autoconf.sh
./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME} --build=`gcc -dumpmachine`
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
