cd ${OUTPUT_DIR}${INSTALL_PREFIX}
mkdir -p lib
mkdir -p libexec

rm -rf ${OUTPUT_DIR}/dev
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/include

cp /opt/local/bin/realpath libexec/.

sed "s|___BRANDING___|${BRANDING}|g" -i ${OUTPUT_DIR}${INSTALL_PREFIX}/environment

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
export PYTHONEXECUTABLE="\$release_topdir_abs/bin/yshqpy3"
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
            install_name_tool -add_rpath @executable_path/../Frameworks libexec/$(basename $binfile)
            cat >> $binfile << EOT
export QT_PLUGIN_PATH="\$release_topdir_abs/lib/qt5/plugins"
export QT_LOGGING_RULES="*=false"
unset QT_QPA_PLATFORMTHEME
unset QT_STYLE_OVERRIDE
export XDG_DATA_DIRS="\$release_topdir_abs"/share
export XDG_CONFIG_DIRS="\$release_topdir_abs"
export XDG_CONFIG_HOME=\$HOME/.config/yosyshq
export XDG_CACHE_HOME=\$HOME/.cache/yosyshq
export XDG_DATA_HOME=\$HOME/.local/share/yosyshq
export LC_ALL="C"
mkdir -p \$HOME/.config/yosyshq \$HOME/.local/share/yosyshq
EOT
        fi
        if [ ! -z "$(otool -L libexec/$(basename $binfile) | grep libgtk)" ]; then
# Set and unset variables according to:
# https://refspecs.linuxbase.org/gtk/2.6/gtk/gtk-running.html
# https://specifications.freedesktop.org/basedir-spec/0.6/ar01s03.html
            cat >> $binfile << EOT
unset GTK_MODULES
unset GTK2_MODULES
#unset GTK3_MODULES
export GTK_PATH="\$release_topdir_abs/lib"
export GTK_IM_MODULE=""
export GTK_IM_MODULE_FILE="/dev/null"
export GTK2_RC_FILES="\$release_topdir_abs/lib/gtkrc"
export GTK_EXE_PREFIX="\$release_topdir_abs"
export GTK_DATA_PREFIX="\$release_topdir_abs"
export GDK_PIXBUF_MODULEDIR="\$release_topdir_abs/lib/gdk-pixbuf-2.0/loaders"
export GDK_PIXBUF_MODULE_FILE="\$release_topdir_abs/lib/gdk-pixbuf-2.0/loaders.cache"
#export GTK_THEME="Adwaita"
export XDG_DATA_DIRS="\$release_topdir_abs"/share
export XDG_CONFIG_DIRS="\$release_topdir_abs"
export XDG_CONFIG_HOME=\$HOME/.config/yosyshq
export XDG_CACHE_HOME=\$HOME/.cache/yosyshq
export XDG_DATA_HOME=\$HOME/.local/share/yosyshq
export LC_ALL="C"
export TCL_LIBRARY="\$release_topdir_abs/lib/tcl8.6"
export TK_LIBRARY="\$release_topdir_abs/lib/tk8.6"
"\$release_topdir_abs"/libexec/gdk-pixbuf-query-loaders --update-cache
mkdir -p \$HOME/.config/yosyshq \$HOME/.local/share/yosyshq
EOT
        fi

        cat >> $binfile << EOT
exec "\$release_topdir_abs"/libexec/$(basename $binfile) "\$@"
EOT
        chmod +x $binfile
    done
done

if [ -f "py3bin/python3" ]; then
    mkdir -p bin
    cp py3bin/python3 bin/yshqpy3
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
export PYTHONEXECUTABLE="\$release_bindir_abs/yshqpy3"
EOT
        if [ $script == 'bin/xdot' ]; then
# Set and unset variables according to:
# https://refspecs.linuxbase.org/gtk/2.6/gtk/gtk-running.html
# https://specifications.freedesktop.org/basedir-spec/0.6/ar01s03.html
            cat >> "${script}" <<EOT
unset GTK_MODULES
unset GTK3_MODULES
export GTK_PATH="\$release_topdir_abs/lib"
export GTK_IM_MODULE=""
export GTK_IM_MODULE_FILE="/dev/null"
export GTK_EXE_PREFIX="\$release_topdir_abs"
export GTK_DATA_PREFIX="\$release_topdir_abs"
export GDK_PIXBUF_MODULEDIR="\$release_topdir_abs/lib/gdk-pixbuf-2.0/loaders"
export GDK_PIXBUF_MODULE_FILE="\$release_topdir_abs/lib/gdk-pixbuf-2.0/loaders.cache"
export GTK_THEME="Adwaita"
export XDG_DATA_DIRS="\$release_topdir_abs"/share
export XDG_CONFIG_DIRS="\$release_topdir_abs"
export XDG_CONFIG_HOME=\$HOME/.config/yosyshq
export XDG_CACHE_HOME=\$HOME/.cache/yosyshq
export XDG_DATA_HOME=\$HOME/.local/share/yosyshq
export TCL_LIBRARY="\$release_topdir_abs/lib/tcl8.6"
export TK_LIBRARY="\$release_topdir_abs/lib/tk8.6"
export LC_ALL="C"
export GI_TYPELIB_PATH="\$release_topdir_abs/lib/girepository-1.0"
"\$release_topdir_abs"/libexec/gdk-pixbuf-query-loaders --update-cache
mkdir -p \$HOME/.config/yosyshq \$HOME/.local/share/yosyshq
EOT
        fi
        cat >> "${script}" <<EOT
exec \$release_bindir_abs/yshqpy3 "\$release_topdir_abs"/libexec/$(basename $script) "\$@"
EOT
        chmod +x "${script}"
    fi
done

for binfile in $(find lib -type f | xargs file | grep Mach-O | grep bundle | cut -f1 -d:); do
    echo $binfile
    dylibbundler -of -b -x $binfile -p @executable_path/../lib -d ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
done

chmod -R u=rwX,go=rX *
