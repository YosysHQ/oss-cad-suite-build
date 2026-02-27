mkdir -p bitwuzla/deps/install
cp -r btor2tools/${INSTALL_PREFIX}/* bitwuzla/deps/install/.
cp -r cadical/${INSTALL_PREFIX}/* bitwuzla/deps/install/.
cp -r lingeling/${INSTALL_PREFIX}/* bitwuzla/deps/install/.
cp -r symfpu/${INSTALL_PREFIX}/* bitwuzla/deps/install/.

python3 -m venv meson_env
source meson_env/bin/activate

pip install --upgrade pip
pip install meson ninja

cd bitwuzla

if [ ${ARCH_BASE} == 'windows' ]; then
    export CMAKE_TOOLCHAIN_FILE=${PATCHES_DIR}/Toolchain-mingw64.cmake
fi
./configure.py --prefix "/"
cd build 
DESTDIR=${OUTPUT_DIR}${INSTALL_PREFIX} ninja -j${NPROC} install
mkdir ${OUTPUT_DIR}/dev
cp -r ${OUTPUT_DIR}${INSTALL_PREFIX}/include ${OUTPUT_DIR}/dev/include
cp -r  ${OUTPUT_DIR}${INSTALL_PREFIX}/lib ${OUTPUT_DIR}/dev/lib
# Do not expose includes and libs in final package
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/include
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib

cd ../../
deactivate
rm -rf meson_env
