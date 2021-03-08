cd ${OUTPUT_DIR}${INSTALL_PREFIX}
mkdir -p lib
mkdir -p libexec

if [ ${ARCH_BASE} == 'linux' ]; then
# Linux section
if [ ${ARCH} == 'linux-x64' ]; then
    ldlinuxname="ld-linux-x86-64.so.2"
    arch_prefix="x86_64-linux-gnu"
elif [ ${ARCH} == 'linux-arm64' ]; then
    ldlinuxname="ld-linux-aarch64.so.1"
    arch_prefix="aarch64-linux-gnu"
elif [ ${ARCH} == 'linux-arm' ]; then
    ldlinuxname="ld-linux-armhf.so.3"
    arch_prefix="arm-linux-gnueabihf"
fi
for bindir in bin py2bin py3bin super_prove/bin; do
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
export PYTHONHOME="\$release_topdir_abs"
export PYTHONNOUSERSITE=1
EOT
        if [ $bindir == 'py3bin' ]; then
            cat >> $binfile << EOT
export PYTHONEXECUTABLE="\$release_topdir_abs/bin/packaged_py3"
EOT
        fi
        if [ $bindir == 'py2bin' ]; then
            cat >> $binfile << EOT
export PYTHONEXECUTABLE="\$release_topdir_abs/bin/packaged_py2"
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

cp py3bin/python3 bin/packaged_py3
cp py2bin/python2 bin/packaged_py2

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
exec \$release_bindir_abs/packaged_py3 "\$release_topdir_abs"/libexec/$(basename $script) "\$@"
EOT
        chmod +x "${script}"
    fi
done

bin/packaged_py3 -m pip install flask --no-cache-dir --disable-pip-version-check --target=${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages
bin/packaged_py2 -m pip install future --no-cache-dir --disable-pip-version-check --target=${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python2.7/site-packages

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
# end of Linux section
elif [ ${ARCH_BASE} == 'darwin' ]; then
# Darwin/macOS section
cp /usr/local/bin/realpath libexec/.

export DYLD_LIBRARY_PATH=/usr/local/opt/icu4c/lib:$DYLD_LIBRARY_PATH

for bindir in bin py3bin super_prove/bin; do
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
export PYTHONHOME="\$release_topdir_abs"
export PYTHONNOUSERSITE=1
EOT
        if [ $bindir == 'py3bin' ]; then
            cat >> $binfile << EOT
export PYTHONEXECUTABLE="\$release_topdir_abs/bin/packaged_py3"
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

cp py3bin/python3 bin/packaged_py3

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
exec \$release_bindir_abs/packaged_py3 "\$release_topdir_abs"/libexec/$(basename $script) "\$@"
EOT
        chmod +x "${script}"
    fi
done

bin/packaged_py3 -m pip install flask --no-cache-dir --disable-pip-version-check --target=${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.8/site-packages

for binfile in $(find -x lib | xargs file | grep Mach-O | grep bundle | cut -f1 -d:); do
    echo $binfile
    dylibbundler -of -b -x $binfile -p @executable_path/../lib -d ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
done

# end of Darwin/macOS section
elif [ ${ARCH_BASE} == 'windows' ]; then
# Windows section
for bindir in bin py3bin; do
	for f in `ntldd -R ${OUTPUT_DIR}${INSTALL_PREFIX}/$bindir/*.exe | grep mingw64 | sed -e 's/.*=..//' | sed -e 's/ (0.*)//'`; do
		cp -v "$f" lib/.
	done
done

for libdir in lib; do
    for libfile in $(find $libdir -type f | xargs file | grep DLL | cut -f1 -d:); do
        for lib in $(ntldd -R $libfile | grep mingw64 | sed -e 's/.*=..//' | sed -e 's/ (0.*)//'); do
            cp "${lib}" lib/.
        done
    done
done

for script in bin/* py3bin/*; do
    if $(head -1 "${script}" | grep -q python); then
		if [[ $script == *-script.py ]]; then
			gcc -DGUI=0 -O -s -o ${script/-script.py/.exe} ${PATCHES_DIR}/win-launcher.c
		elif [[ $script == */icebox.py ]]; then
			echo "Ignore icebox.py"
		else
			mv ${script} ${script/.py/}-script.py
			gcc -DGUI=0 -O -s -o ${script/.py/}.exe ${PATCHES_DIR}/win-launcher.c
		fi
    fi
done
mv libexec/iceboxdb.py bin/.
# end of Windows section
fi

chmod -R u=rwX,go=rX *
