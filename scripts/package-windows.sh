cd ${OUTPUT_DIR}${INSTALL_PREFIX}
mkdir -p lib
mkdir -p libexec

rm -rf ${OUTPUT_DIR}/dev
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/include

sed "s|___BRANDING___|${BRANDING}|g" -i ${OUTPUT_DIR}${INSTALL_PREFIX}/environment.bat

cp /usr/x86_64-w64-mingw32/sys-root/mingw/bin/*.dll lib/.
for f in $(find . -type l)
do
    cp --remove-destination $(readlink -e $f) $f
done
for script in bin/* py3bin/*; do
    if $(head -1 "${script}" | grep -q python); then
		if [[ $script == *-script.py ]]; then
			cp ${OUTPUT_DIR}${INSTALL_PREFIX}/win-launcher.exe ${script/-script.py/.exe}
		elif [[ $script == */icebox.py ]]; then
			echo "Ignore icebox.py"
		else
			mv ${script} ${script/.py/}-script.py
			cp ${OUTPUT_DIR}${INSTALL_PREFIX}/win-launcher.exe ${script/.py/}.exe
		fi
    fi
done

rm ${OUTPUT_DIR}${INSTALL_PREFIX}/win-launcher.exe

chmod -R u=rwX,go=rX *
