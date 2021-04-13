cd ${OUTPUT_DIR}${INSTALL_PREFIX}

cp /usr/local/bin/realpath libexec/.

export DYLD_LIBRARY_PATH=/usr/local/opt/icu4c/lib:$DYLD_LIBRARY_PATH

mkdir -p lib
mkdir -p libexec

for bindir in ${BIN_DIRS}; do
    for binfile in $(file -h $bindir/* | grep Mach-O | grep executable | cut -f1 -d:); do
        rel_path=$(realpath --relative-to=$bindir ../..)
        rel_path_pkg=$(realpath --relative-to=$bindir .)
        dylibbundler -of -b -x $binfile -p @executable_path/../lib -d lib
        mv $binfile libexec
        is_using_fonts=false
        cat > $binfile << EOT
#!/usr/bin/env bash
release_exedir="\$(dirname \$(pwd)/\$(readlink "\${BASH_SOURCE[0]}"))"
release_topdir_abs="\$("\$release_exedir"/$rel_path/libexec/realpath "\$release_exedir/$rel_path")"
release_bindir_abs="\$release_topdir_abs/bin"
release_pkgdir_abs="\$("\$release_exedir"/$rel_path/libexec/realpath "\$release_exedir/$rel_path_pkg")"
export PATH="\$release_bindir_abs:\$PATH"
EOT
        if [ $bindir == 'py3bin' ]; then
            cat >> $binfile << EOT
export PYTHONEXECUTABLE="\$release_topdir_abs/bin/packaged_py3"
EOT
        fi
        if [ ! -z "$(basename $binfile | grep verilator)" ]; then
            cat >> $binfile << EOT
export VERILATOR_ROOT="\$release_topdir_abs/packages/verilator/share/verilator"
EOT
        fi
        if [ ! -z "$(basename $binfile | grep ghdl)" ]; then
            cat >> $binfile << EOT
export GHDL_PREFIX="\$release_topdir_abs/lib/ghdl"
EOT
        fi
        if [ ! -z "$(otool -L libexec/$(basename $binfile) | grep python)" ]; then
            cat >> $binfile << EOT
export PYTHONHOME="\$release_topdir_abs"/packages/python3
export PYTHONNOUSERSITE=1
EOT
        fi
        if [ ! -z "$(otool -L libexec/$(basename $binfile) | grep QtCore)" ]; then
            is_using_fonts=true
            cat >> $binfile << EOT
export QT_PLUGIN_PATH="\$release_topdir_abs/lib/qt5/plugins"
export QT_LOGGING_RULES="*=false"
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
exec "\$release_pkgdir_abs"/libexec/$(basename $binfile) "\$@"
EOT
        chmod +x $binfile
    done
done

if [ -f "py3bin/python3" ]; then
    mkdir -p bin
    cp py3bin/python3 bin/packaged_py3
fi

for scriptdir in ${PY_DIRS}; do
    for script in $(file $scriptdir/* | cut -f1 -d:); do
        rel_path=$(realpath --relative-to=bin ../..)
        rel_path_pkg=$(realpath --relative-to=bin .)
        if $(head -1 "${script}" | grep -q python3); then
            mv "${script}" libexec
            cat > "${script}" <<EOT
#!/usr/bin/env bash
release_exedir="\$(dirname \$(pwd)/\$(readlink "\${BASH_SOURCE[0]}"))"
release_topdir_abs="\$("\$release_exedir"/$rel_path/libexec/realpath "\$release_exedir/$rel_path")"
release_bindir_abs="\$release_topdir_abs/bin"
release_pkgdir_abs="\$("\$release_exedir"/$rel_path/libexec/realpath "\$release_exedir/$rel_path_pkg")"
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
exec \$release_bindir_abs/packaged_py3 "\$release_pkgdir_abs"/libexec/$(basename $script) "\$@"
EOT
            chmod +x "${script}"
        fi
    done
done
