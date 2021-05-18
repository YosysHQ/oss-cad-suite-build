export PKG_CONFIG_ALLOW_CROSS=YES
cargo install --no-track --path ecpdap --root ${OUTPUT_DIR}${INSTALL_PREFIX} --target=${CARGO_TARGET}
