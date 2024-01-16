source ${PATCHES_DIR}/python3_package.sh

cp -r tinyfpgab/programmer/* tinyfpgab/.
cp -r tinyprog/programmer/* tinyprog/.

python3_package_setup
python3_package_pip_install "rpds-py==0.16.1"
export CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse
for target in *; do
    if [ $target != 'python3' ] && [ $target != 'python3-native' ]; then
        pushd $target
        if [ $target == 'tinyprog' ]; then
            export SETUPTOOLS_SCM_PRETEND_VERSION="1.0.23"
        fi
        python3_package_install
        popd
    fi
done
python3_package_pth "python-programmers"
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/tqdm
rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/jsonschema
for f in ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/*.py
do
    [ -f "$f" ] && mv "$f" "${f%.py}"
done