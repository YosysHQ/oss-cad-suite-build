cd imctk
rm -rf abc-sys/codegen.sh
sed -i 's,debug = true,#debug = true,g' Cargo.toml
sed -i 's,pub const l_False,//pub const l_False,g' abc-sys/src/generated/bindings.rs
RUSTFLAGS="-A dangerous-implicit-autorefs" cargo install --no-track --path eqy-engine --root ${OUTPUT_DIR}${INSTALL_PREFIX} --target=${CARGO_TARGET}
