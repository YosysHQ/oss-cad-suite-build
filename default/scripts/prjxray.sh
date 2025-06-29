mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/share/xray
cp -r prjxray-db ${OUTPUT_DIR}${INSTALL_PREFIX}/share/xray/database

cd prjxray
source ${PATCHES_DIR}/python3_package.sh
mv utils/fasm2frames.py prjxray/.
sed -E 's/(fasm2frames=)utils/\1prjxray/' -i setup.py
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -B build
make -C build DESTDIR=${OUTPUT_DIR} -j${NPROC} install
python3_package_setup
# Technically numpy is also a dependency, but it looks like it is not used
# during the build process nor by any installed artifacts.
for dep in fasm intervaltree pyjson5 pyyaml simplejson; do
    python3_package_pip_install ${dep}
done
python3_package_install --old-and-unmanageable
