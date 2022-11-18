cd ${OUTPUT_DIR}${INSTALL_PREFIX}
mkdir -p lib

rm -rf ${OUTPUT_DIR}/dev
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/include/ghdl
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/yosys

cp ${PATCHES_DIR}/${README} ${OUTPUT_DIR}${INSTALL_PREFIX}/README
sed "s|___BRANDING___|${BRANDING}|g" -i ${OUTPUT_DIR}${INSTALL_PREFIX}/environment.bat
if [ -f "${OUTPUT_DIR}${INSTALL_PREFIX}/bin/tabbyadm" ]; then
	sed "s|___BRANDING___|${BRANDING}|g" -i ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/tabbyadm
fi

# We copy all DLLs that we are using
cp /usr/x86_64-w64-mingw32/sys-root/mingw/bin/*.dll lib/.

# Replace symbolic links with actual files
for f in $(find . -type l)
do
    cp --remove-destination $(readlink -e $f) $f
done

# Replace python scripts with python launchers
for script in bin/* py3bin/*; do
    if $(head -1 "${script}" | grep -q python); then
		if [[ $script == *-script.py ]]; then
			cp ${OUTPUT_DIR}${INSTALL_PREFIX}/win-launcher.exe ${script/-script.py/.exe}
		else
			mv ${script} ${script/.py/}-script.py
			cp ${OUTPUT_DIR}${INSTALL_PREFIX}/win-launcher.exe ${script/.py/}.exe
		fi
    fi
done

# Remove general purpose launcher
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/win-launcher.exe

chmod -R u=rwX,go=rX *
