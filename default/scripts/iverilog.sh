cd iverilog
sed -i "s/\$(CC) \$(CFLAGS) -o draw_tt/gcc \$(CFLAGS) -o draw_tt/g" vvp/Makefile.in
if [ ${ARCH_BASE} == 'windows' ]; then
    if [ ${IS_NATIVE} != 'True' ]; then
        sed -i "s,\$(bindir)/iverilog-vpi,\$(DESTDIR)\$(bindir)/iverilog-vpi,g" driver-vpi/Makefile.in 
        sed -i "s,\$(srcdir)/../mkinstalldirs \"\$(bindir)\",\$(srcdir)/../mkinstalldirs \"\$(DESTDIR)\$(bindir)\",g" driver-vpi/Makefile.in
    fi
fi
sh autoconf.sh
./configure --prefix=${INSTALL_PREFIX} --host=${CROSS_NAME}
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install
