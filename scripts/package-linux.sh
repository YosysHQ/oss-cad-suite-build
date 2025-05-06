cd ${OUTPUT_DIR}${INSTALL_PREFIX}
mkdir -p lib
mkdir -p libexec

rm -rf ${OUTPUT_DIR}/dev
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/include/ghdl

if [ ${ARCH} == 'linux-x64' ]; then
    ldlinuxname="ld-linux-x86-64.so.2"
    arch_prefix="x86_64-linux-gnu"
elif [ ${ARCH} == 'linux-arm64' ]; then
    ldlinuxname="ld-linux-aarch64.so.1"
    arch_prefix="aarch64-linux-gnu"
fi

cp ${PATCHES_DIR}/${README} ${OUTPUT_DIR}${INSTALL_PREFIX}/README
sed "s|___BRANDING___|${BRANDING}|g" -i ${OUTPUT_DIR}${INSTALL_PREFIX}/environment
if [ -f "${OUTPUT_DIR}${INSTALL_PREFIX}/environment.fish" ]; then
    sed "s|___BRANDING___|${BRANDING}|g" -i ${OUTPUT_DIR}${INSTALL_PREFIX}/environment.fish
fi
if [ -f "${OUTPUT_DIR}${INSTALL_PREFIX}/bin/tabbyadm" ]; then
    sed "s|___BRANDING___|${BRANDING}|g" -i ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/tabbyadm
fi

preload_tools=(
    "py3bin/python3.11"
    "bin/mcy-gui"
    "bin/sby-gui"
)

for bindir in bin py2bin py3bin super_prove/bin share/verilator/bin lib/ivl; do
    for binfile in $(file $bindir/* | grep ELF | grep dynamically | grep interpreter | cut -f1 -d:); do
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
export PYTHONEXECUTABLE="\$release_topdir_abs/bin/tabbypy3"
EOT
        fi
        if [ ! -z "$(basename $binfile | grep verilator)" ]; then
            cat >> $binfile << EOT
export VERILATOR_ROOT="\$release_topdir_abs/share/verilator"
EOT
        fi
        if [ ! -z "$(basename $binfile | grep openFPGALoader)" ]; then
            cat >> $binfile << EOT
export OPENFPGALOADER_SOJ_DIR="\$release_topdir_abs/share/openFPGALoader"
EOT
        fi
        if [ ! -z "$(basename $binfile | grep iverilog)" ]; then
            cat >> $binfile << EOT
set -- "-p" "VVP_EXECUTABLE=\$release_topdir_abs/bin/vvp" "\$@"
EOT
        fi
        if [ ! -z "$(basename $binfile | grep vvp)" ]; then
            cat >> $binfile << EOT
export PYTHONEXECUTABLE="\$release_topdir_abs/bin/tabbypy3"
export PYTHONHOME="\$release_topdir_abs"
EOT
        fi
        if [ ! -z "$(strings libexec/$(basename $binfile) | grep ghdl)" ]; then
            cat >> $binfile << EOT
export GHDL_PREFIX="\$release_topdir_abs/lib/ghdl"
EOT
        fi
        if [ $binfile == "bin/yosys" ] && [ -f "share/yosys/plugins/ghdl.so" ]; then
            cat >> $binfile << EOT
export GHDL_PREFIX="\$release_topdir_abs/lib/ghdl"
EOT
        fi
        if [ ! -z "$(lddtree -l libexec/$(basename $binfile) | grep python)" ]; then
            cat >> $binfile << EOT
export PYTHONHOME="\$release_topdir_abs"
export PYTHONNOUSERSITE=1
export SSL_CERT_FILE="\$release_topdir_abs"/etc/cacert.pem
EOT
        fi
        if [ ! -z "$(lddtree -l libexec/$(basename $binfile) | grep tcl)" ]; then
            cat >> $binfile << EOT
export TCL_LIBRARY="\$release_topdir_abs/lib/tcl8.6"
export TK_LIBRARY="\$release_topdir_abs/lib/tk8.6"
EOT
        fi
        if [ ! -z "$(lddtree -l libexec/$(basename $binfile) | grep Qt5)" ]; then
            is_using_fonts=true
            cat >> $binfile << EOT
export LIBGL_DRIVERS_PATH="\$release_topdir_abs/lib/dri"
export QT_PLUGIN_PATH="\$release_topdir_abs/lib/qt5/plugins"
export QT_LOGGING_RULES="*=false"
unset QT_QPA_PLATFORMTHEME
unset QT_STYLE_OVERRIDE
export XDG_DATA_DIRS="\$release_topdir_abs"/share
export XDG_CONFIG_DIRS="\$release_topdir_abs"
export XDG_CONFIG_HOME=\$HOME/.config/yosyshq
export XDG_CACHE_HOME=\$HOME/.cache/yosyshq
export XDG_DATA_HOME=\$HOME/.local/share/yosyshq
export XDG_CURRENT_DESKTOP="KDE"
export LC_ALL="C"
mkdir -p \$XDG_CONFIG_HOME \$XDG_CACHE_HOME \$XDG_DATA_HOME
EOT
        fi
        if [ ! -z "$(lddtree -l libexec/$(basename $binfile) | grep gtk)" ]; then
# Set and unset variables according to:
# https://refspecs.linuxbase.org/gtk/2.6/gtk/gtk-running.html
# https://specifications.freedesktop.org/basedir-spec/0.6/ar01s03.html
            is_using_fonts=true
            cat >> $binfile << EOT
unset GTK_MODULES
unset GTK3_MODULES
export GTK_PATH="\$release_topdir_abs/lib"
export GTK_IM_MODULE=""
export GTK_IM_MODULE_FILE="/dev/null"
export GTK_EXE_PREFIX="\$release_topdir_abs"
export GTK_DATA_PREFIX="\$release_topdir_abs"
export GDK_PIXBUF_MODULEDIR="\$release_topdir_abs/lib/gdk-pixbuf-2.0/loaders"
export GTK_THEME="Adwaita"
export XDG_DATA_DIRS="\$release_topdir_abs"/share
export XDG_CONFIG_DIRS="\$release_topdir_abs"
export XDG_CONFIG_HOME=\$HOME/.config/yosyshq
export XDG_CACHE_HOME=\$HOME/.cache/yosyshq
export XDG_DATA_HOME=\$HOME/.local/share/yosyshq
export XDG_CURRENT_DESKTOP="KDE"
export LC_ALL="C"
export GDK_PIXBUF_MODULE_FILE="\$XDG_CACHE_HOME/loaders.cache"
mkdir -p \$XDG_CONFIG_HOME \$XDG_CACHE_HOME \$XDG_DATA_HOME
"\$release_topdir_abs"/lib/$ldlinuxname --inhibit-cache --inhibit-rpath "" --library-path "\$release_topdir_abs"/lib "\$release_topdir_abs"/libexec/gdk-pixbuf-query-loaders --update-cache
EOT
        fi

        if $is_using_fonts; then
            cat >> $binfile << EOT
export FONTCONFIG_FILE="\$XDG_CONFIG_HOME/fonts.conf"
export FONTCONFIG_PATH="\$release_topdir_abs/etc/fonts"
sed "s|TARGET_DIR|\$release_topdir_abs|g" "\$release_topdir_abs/etc/fonts/fonts.conf.template" > \$FONTCONFIG_FILE
EOT
        fi

found=false

for path in "${preload_tools[@]}"; do
    if [[ "$binfile" == "$path" ]]; then
        found=true
        break
    fi
done

if [ ${PRELOAD} == 'True' ]; then
    if $found; then
        cat >> $binfile << EOT
exec "\$release_topdir_abs"/lib/$ldlinuxname --inhibit-cache --inhibit-rpath "" --library-path "\$release_topdir_abs"/lib --preload "\$release_topdir_abs"/lib/preload.o "\$release_topdir_abs"/libexec/$(basename $binfile) "\$@"
EOT
        chmod +x $binfile
        continue
    else
        echo "Skipping"
    fi
fi
        cat >> $binfile << EOT
exec "\$release_topdir_abs"/lib/$ldlinuxname --inhibit-cache --inhibit-rpath "" --library-path "\$release_topdir_abs"/lib "\$release_topdir_abs"/libexec/$(basename $binfile) "\$@"
EOT
        chmod +x $binfile
    done
done

if [ -f "py3bin/python3" ]; then
    mkdir -p bin
    cp py3bin/python3 bin/tabbypy3
    cp py3bin/pip3 bin/tabbypip
fi

for script in bin/* py3bin/*; do
    rel_path=$(realpath --relative-to=bin .)
    if $(head -1 "${script}" | grep -q python); then
        mv "${script}" libexec
        cat > "${script}" <<EOT
#!/usr/bin/env bash
release_bindir="\$(dirname "\${BASH_SOURCE[0]}")"
release_bindir_abs="\$(readlink -f "\$release_bindir/../bin")"
release_topdir_abs="\$(readlink -f "\$release_bindir/$rel_path")"
export PATH="\$release_bindir_abs:\$PATH"
export PYTHONEXECUTABLE="\$release_bindir_abs/tabbypy3"
EOT
        is_using_fonts=false
        if [ $script == 'bin/xdot' ]; then
# Set and unset variables according to:
# https://refspecs.linuxbase.org/gtk/2.6/gtk/gtk-running.html
# https://specifications.freedesktop.org/basedir-spec/0.6/ar01s03.html
            is_using_fonts=true
            cat >> "${script}" <<EOT
unset GTK_MODULES
unset GTK3_MODULES
export GTK_PATH="\$release_topdir_abs/lib"
export GTK_IM_MODULE=""
export GTK_IM_MODULE_FILE="/dev/null"
export GTK_EXE_PREFIX="\$release_topdir_abs"
export GTK_DATA_PREFIX="\$release_topdir_abs"
export GDK_PIXBUF_MODULEDIR="\$release_topdir_abs/lib/gdk-pixbuf-2.0/loaders"
export GTK_THEME="Adwaita"
export XDG_DATA_DIRS="\$release_topdir_abs"/share
export XDG_CONFIG_DIRS="\$release_topdir_abs"
export XDG_CONFIG_HOME=\$HOME/.config/yosyshq
export XDG_CACHE_HOME=\$HOME/.cache/yosyshq
export XDG_DATA_HOME=\$HOME/.local/share/yosyshq
export XDG_CURRENT_DESKTOP="KDE"
export TCL_LIBRARY="\$release_topdir_abs/lib/tcl8.6"
export TK_LIBRARY="\$release_topdir_abs/lib/tk8.6"
export GDK_PIXBUF_MODULE_FILE="\$XDG_CACHE_HOME/loaders.cache"
mkdir -p \$XDG_CONFIG_HOME \$XDG_CACHE_HOME \$XDG_DATA_HOME
"\$release_topdir_abs"/lib/$ldlinuxname --inhibit-cache --inhibit-rpath "" --library-path "\$release_topdir_abs"/lib "\$release_topdir_abs"/libexec/gdk-pixbuf-query-loaders --update-cache
export LC_ALL="C"
export GI_TYPELIB_PATH="\$release_topdir_abs/lib/girepository-1.0"
EOT
        fi
        if $is_using_fonts; then
            cat >> "${script}" <<EOT
export FONTCONFIG_FILE="\$XDG_CONFIG_HOME/fonts.conf"
export FONTCONFIG_PATH="\$release_topdir_abs/etc/fonts"
sed "s|TARGET_DIR|\$release_topdir_abs|g" "\$release_topdir_abs/etc/fonts/fonts.conf.template" > \$FONTCONFIG_FILE
EOT
        fi
        cat >> "${script}" <<EOT
exec \$release_bindir_abs/tabbypy3 "\$release_topdir_abs"/libexec/$(basename $script) "\$@"
EOT
        chmod +x "${script}"
    fi
done


for lib in /lib/$arch_prefix/libnss_dns.so.2 /lib/$arch_prefix/libnss_files.so.2 /lib/$arch_prefix/libnss_compat.so.2 /lib/$arch_prefix/libresolv.so.2 /lib/$arch_prefix/libnss_hesiod.so.2; do
    cp "${lib}" lib/
done

for libdir in lib; do
    for libfile in $(find $libdir -type f | xargs file | grep ELF | grep dynamically | cut -f1 -d:); do
        for lib in $(lddtree -l $libfile | tail -n +2 | grep ^/ ); do
            cp -i "${lib}" lib/
        done
    done
done

# Fix for WSL (Windows Subsystem for Linux)
if [ ${ARCH} == 'linux-x64' ]; then
    if [ -f "lib/libQt5Core.so.5" ]; then
        ${STRIP} --remove-section=.note.ABI-tag lib/libQt5Core.so.5
    fi
fi

if [ -f "bin/yosys-config" ]; then
    mv bin/yosys-config bin/yosys-config.orig
    cat > bin/yosys-config << EOT
#!/usr/bin/env bash
release_bindir="\$(dirname "\${BASH_SOURCE[0]}")"
release_bindir_abs="\$(readlink -f "\$release_bindir")"
release_topdir_abs="\$(readlink -f "\$release_bindir/$rel_path")"
EOT
    cat bin/yosys-config.orig >> bin/yosys-config
    rm bin/yosys-config.orig
    sed -i "s,\"/yosyshq,\${release_topdir_abs}\",g" bin/yosys-config
    sed -i "s,'/yosyshq,\${release_topdir_abs}',g" bin/yosys-config
    sed -i "s,/yosyshq,\${release_topdir_abs},g" bin/yosys-config
    chmod +x bin/yosys-config
fi

chmod -R u=rwX,go=rX *
