cd ${OUTPUT_DIR}${INSTALL_PREFIX}
mkdir -p lib
mkdir -p libexec

rm -rf ${OUTPUT_DIR}/dev
rm -rf ${OUTPUT_DIR}/include

cp /usr/local/bin/realpath libexec/.

export DYLD_LIBRARY_PATH=/usr/local/opt/icu4c/lib:$DYLD_LIBRARY_PATH

for bindir in bin py3bin super_prove/bin share/verilator/bin; do
    for binfile in $(file -h $bindir/* | grep Mach-O | grep executable | cut -f1 -d:); do
        rel_path=$(realpath --relative-to=$bindir .)
        dylibbundler -of -b -x $binfile -p @executable_path/../lib -d lib
        mv $binfile libexec
        is_using_fonts=false
        cat > $binfile << EOT
#!/usr/bin/env bash
release_bindir="\$(dirname "\${BASH_SOURCE[0]}")"
release_bindir_abs="\$("\$release_bindir"/../libexec/realpath "\$release_bindir")"
release_topdir_abs="\$("\$release_bindir"/../libexec/realpath "\$release_bindir/$rel_path")"
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
        if [ ! -z "$(otool -L libexec/$(basename $binfile) | grep python)" ]; then
            cat >> $binfile << EOT
export PYTHONHOME="\$release_topdir_abs"
export PYTHONNOUSERSITE=1
EOT
        fi
        if [ ! -z "$(otool -L libexec/$(basename $binfile) | grep QtCore)" ]; then
            is_using_fonts=true
            cat >> $binfile << EOT
export QT_PLUGIN_PATH="\$release_topdir_abs/lib/qt5/plugins"
unset QT_QPA_PLATFORMTHEME
unset QT_STYLE_OVERRIDE
export XDG_CONFIG_HOME="\$release_topdir_abs"
EOT
        fi
        if [ ! -z "$(otool -L libexec/$(basename $binfile) | grep libgtk)" ]; then
            is_using_fonts=true
            cat >> $binfile << EOT
export GTK_PATH="\$release_topdir_abs/lib/gtk-2.0" GTK_MODULES="" GTK_IM_MODULE="" GTK_IM_MODULE_FILE="/dev/null"
export GTK2_MODULES="" GTK_EXE_PREFIX="\$release_topdir_abs" GTK_DATA_PREFIX="\$release_topdir_abs"
export GDK_PIXBUF_MODULEDIR="\$release_topdir_abs/lib/gtk-2.0/loaders"
export GDK_PIXBUF_MODULE_FILE="\$release_topdir_abs/lib/gtk-2.0/loaders.cache" LC_ALL="C"
export TCL_LIBRARY="\$release_topdir_abs/lib/tcl8.6"
export TK_LIBRARY="\$release_topdir_abs/lib/tk8.6"
export GTK2_RC_FILES="\$release_topdir_abs/lib/gtk-2.0/gtkrc"
"\$release_topdir_abs"/libexec/gdk-pixbuf-query-loaders --update-cache

EOT
        fi

        cat >> $binfile << EOT
exec "\$release_topdir_abs"/libexec/$(basename $binfile) "\$@"
EOT
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
release_bindir_abs="\$("\$release_bindir"/../libexec/realpath "\$release_bindir/../bin")"
release_topdir_abs="\$("\$release_bindir"/../libexec/realpath "\$release_bindir/$rel_path")"
export PATH="\$release_bindir_abs:\$PATH"
export PYTHONEXECUTABLE="\$release_bindir_abs/packaged_py3"
EOT
        if [ $script == 'bin/xdot' ]; then
            cat >> "${script}" <<EOT
export GTK_PATH="\$release_topdir_abs/lib/gtk-2.0" GTK_MODULES="" GTK_IM_MODULE="" GTK_IM_MODULE_FILE="/dev/null"
export GTK2_MODULES="" GTK_EXE_PREFIX="\$release_topdir_abs" GTK_DATA_PREFIX="\$release_topdir_abs"
export GDK_PIXBUF_MODULEDIR="\$release_topdir_abs/lib/gtk-2.0/loaders"
export GDK_PIXBUF_MODULE_FILE="\$release_topdir_abs/lib/gtk-2.0/loaders.cache" LC_ALL="C"
export TCL_LIBRARY="\$release_topdir_abs/lib/tcl8.6"
export TK_LIBRARY="\$release_topdir_abs/lib/tk8.6"
export GTK2_RC_FILES="\$release_topdir_abs/lib/gtk-2.0/gtkrc"
"\$release_topdir_abs"/libexec/gdk-pixbuf-query-loaders --update-cache
EOT
        fi
        cat >> "${script}" <<EOT
exec \$release_bindir_abs/packaged_py3 "\$release_topdir_abs"/libexec/$(basename $script) "\$@"
EOT
        chmod +x "${script}"
    fi
done

for binfile in $(find -x lib | xargs file | grep Mach-O | grep bundle | cut -f1 -d:); do
    echo $binfile
    dylibbundler -of -b -x $binfile -p @executable_path/../lib -d ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
done

chmod -R u=rwX,go=rX *
