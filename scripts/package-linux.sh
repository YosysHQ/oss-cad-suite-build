cd ${OUTPUT_DIR}${INSTALL_PREFIX}
mkdir -p lib
mkdir -p libexec

rm -rf ${OUTPUT_DIR}/dev
rm -rf ${OUTPUT_DIR}/include

if [ ${ARCH} == 'linux-x64' ]; then
    ldlinuxname="ld-linux-x86-64.so.2"
    arch_prefix="x86_64-linux-gnu"
elif [ ${ARCH} == 'linux-arm64' ]; then
    ldlinuxname="ld-linux-aarch64.so.1"
    arch_prefix="aarch64-linux-gnu"
elif [ ${ARCH} == 'linux-arm' ]; then
    ldlinuxname="ld-linux-armhf.so.3"
    arch_prefix="arm-linux-gnueabihf"
elif [ ${ARCH} == 'linux-riscv64' ]; then
    ldlinuxname="ld-linux-riscv64-lp64d.so.1"
    arch_prefix="riscv64-linux-gnu"
fi

for bindir in bin py2bin py3bin super_prove/bin share/verilator/bin; do
    for binfile in $(file $bindir/* | grep ELF | grep dynamically | cut -f1 -d:); do
        rel_path=$(realpath --relative-to=$bindir .)
        for lib in $(lddtree -l $binfile | tail -n +2 | grep ^/ ); do
            cp -i "${lib}" lib/
        done
        mv $binfile libexec
        is_using_fonts=false
        cat > $binfile << EOT
#!/usr/bin/env bash
release_bindir="\$(dirname "\${BASH_SOURCE[0]}")"
release_bindir_abs="\$(readlink -f "\$release_bindir")"
release_topdir_abs="\$(readlink -f "\$release_bindir/$rel_path")"
export PATH="\$release_bindir_abs:\$PATH"
EOT

        if [ $bindir == 'py3bin' ]; then
            cat >> $binfile << EOT
export PYTHONEXECUTABLE="\$release_topdir_abs/bin/packaged_py3"
EOT
        fi
        if [ ! -z "$(basename $binfile | grep verilator)" ]; then
            cat >> $binfile << EOT
export VERILATOR_ROOT="\$release_topdir_abs/share/verilator"
EOT
        fi
        if [ ! -z "$(basename $binfile | grep ghdl)" ]; then
            cat >> $binfile << EOT
export GHDL_PREFIX="\$release_topdir_abs/lib/ghdl"
EOT
        fi
        if [ ! -z "$(lddtree -l libexec/$(basename $binfile) | grep python)" ]; then
            cat >> $binfile << EOT
export PYTHONHOME="\$release_topdir_abs"
export PYTHONNOUSERSITE=1
EOT
        fi
        if [ ! -z "$(lddtree -l libexec/$(basename $binfile) | grep Qt5)" ]; then
            is_using_fonts=true
            cat >> $binfile << EOT
export QT_PLUGIN_PATH="\$release_topdir_abs/lib/qt5/plugins"
unset QT_QPA_PLATFORMTHEME
unset QT_STYLE_OVERRIDE
unset XDG_DATA_DIRS
export XDG_DATA_HOME="\$release_topdir_abs"
export XDG_CONFIG_HOME="\$release_topdir_abs"
export LC_ALL="C"
export FONTCONFIG_FILE="\$release_topdir_abs/etc/fonts/fonts.conf"
export FONTCONFIG_PATH="\$release_topdir_abs/etc/fonts"
EOT
        fi
        if [ ! -z "$(lddtree -l libexec/$(basename $binfile) | grep gtk)" ]; then
# Set and unset variables according to:
# https://refspecs.linuxbase.org/gtk/2.6/gtk/gtk-running.html
            is_using_fonts=true
            cat >> $binfile << EOT
unset GTK_MODULES
unset GTK2_MODULES
export GTK_PATH="\$release_topdir_abs/lib/gtk-2.0"
export GTK_IM_MODULE=""
export GTK_IM_MODULE_FILE="/dev/null"
export GTK2_RC_FILES="\$release_topdir_abs/lib/gtk-2.0/gtkrc"
export GTK_EXE_PREFIX="\$release_topdir_abs"
export GTK_DATA_PREFIX="\$release_topdir_abs"
export GDK_PIXBUF_MODULE_FILE="\$release_topdir_abs/lib/gtk-2.0/loaders.cache"
unset XDG_DATA_DIRS
export XDG_DATA_HOME="\$release_topdir_abs"
export XDG_CONFIG_HOME="\$release_topdir_abs"
export LC_ALL="C"
export TCL_LIBRARY="\$release_topdir_abs/lib/tcl8.6"
export TK_LIBRARY="\$release_topdir_abs/lib/tk8.6"
export FONTCONFIG_FILE="\$release_topdir_abs/etc/fonts/fonts.conf"
export FONTCONFIG_PATH="\$release_topdir_abs/etc/fonts"
EOT
        fi

        if $is_using_fonts; then
            cat >> $binfile << EOT
if [ -f "\$FONTCONFIG_FILE" ]; then
    exec "\$release_topdir_abs"/lib/$ldlinuxname --inhibit-cache --inhibit-rpath "" --library-path "\$release_topdir_abs"/lib "\$release_topdir_abs"/libexec/$(basename $binfile) "\$@"
else
    echo "Execute \$release_topdir_abs/setup.sh script to do initial setup of YosysHQ configuration files."
fi
EOT
        else
            cat >> $binfile << EOT
exec "\$release_topdir_abs"/lib/$ldlinuxname --inhibit-cache --inhibit-rpath "" --library-path "\$release_topdir_abs"/lib "\$release_topdir_abs"/libexec/$(basename $binfile) "\$@"
EOT
        fi
        chmod +x $binfile
    done
done

if [ -f "py3bin/python3" ]; then
    cp py3bin/python3 bin/packaged_py3
fi

for script in bin/* py3bin/*; do
    rel_path=$(realpath --relative-to=bin .)
    if $(head -1 "${script}" | grep -q python3); then
        mv "${script}" libexec
        cat > "${script}" <<EOT
#!/usr/bin/env bash
release_bindir="\$(dirname "\${BASH_SOURCE[0]}")"
release_bindir_abs="\$(readlink -f "\$release_bindir/../bin")"
release_topdir_abs="\$(readlink -f "\$release_bindir/$rel_path")"
export PATH="\$release_bindir_abs:\$PATH"
export PYTHONEXECUTABLE="\$release_bindir_abs/packaged_py3"
EOT
        is_using_fonts=false
        if [ $script == 'bin/xdot' ]; then
# Set and unset variables according to:
# https://refspecs.linuxbase.org/gtk/2.6/gtk/gtk-running.html
            is_using_fonts=true
            cat >> "${script}" <<EOT
unset GTK_MODULES
unset GTK2_MODULES
export GTK_PATH="\$release_topdir_abs/lib/gtk-2.0"
export GTK_IM_MODULE=""
export GTK_IM_MODULE_FILE="/dev/null"
export GTK2_RC_FILES="\$release_topdir_abs/lib/gtk-2.0/gtkrc"
export GTK_EXE_PREFIX="\$release_topdir_abs"
export GTK_DATA_PREFIX="\$release_topdir_abs"
export GDK_PIXBUF_MODULE_FILE="\$release_topdir_abs/lib/gtk-2.0/loaders.cache"
unset XDG_DATA_DIRS
export XDG_DATA_HOME="\$release_topdir_abs"
export XDG_CONFIG_HOME="\$release_topdir_abs"
export LC_ALL="C"
export TCL_LIBRARY="\$release_topdir_abs/lib/tcl8.6"
export TK_LIBRARY="\$release_topdir_abs/lib/tk8.6"
export FONTCONFIG_FILE="\$release_topdir_abs/etc/fonts/fonts.conf"
export FONTCONFIG_PATH="\$release_topdir_abs/etc/fonts"
EOT
        fi
        if $is_using_fonts; then
            cat >> "${script}" <<EOT
if [ -f "\$FONTCONFIG_FILE" ]; then
    exec \$release_bindir_abs/packaged_py3 "\$release_topdir_abs"/libexec/$(basename $script) "\$@"
else
    echo "Execute \$release_topdir_abs/setup.sh script to do initial setup of YosysHQ configuration files."
fi
EOT
        else
            cat >> "${script}" <<EOT
exec \$release_bindir_abs/packaged_py3 "\$release_topdir_abs"/libexec/$(basename $script) "\$@"
EOT
        fi
        chmod +x "${script}"
    fi
done


for lib in /lib/$arch_prefix/libnss_dns.so.2 /lib/$arch_prefix/libnss_files.so.2 /lib/$arch_prefix/libnss_compat.so.2 /lib/$arch_prefix/libresolv.so.2 \
        /lib/$arch_prefix/libnss_nis.so.2 /lib/$arch_prefix/libnss_nisplus.so.2 /lib/$arch_prefix/libnss_hesiod.so.2 /lib/$arch_prefix/libnsl.so.1; do
    cp "${lib}" lib/
done

for libdir in lib; do
    for libfile in $(find $libdir -type f | xargs file | grep ELF | grep dynamically | cut -f1 -d:); do
        for lib in $(lddtree -l $libfile | tail -n +2 | grep ^/ ); do
            cp -i "${lib}" lib/
        done
    done
done

chmod -R u=rwX,go=rX *
