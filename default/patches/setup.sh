#!/usr/bin/env bash
release_bindir="$(dirname "${BASH_SOURCE[0]}")"
release_topdir_abs="$(realpath "$release_bindir")"
export FONTCONFIG_FILE="$release_topdir_abs/etc/fonts/fonts.conf"
sed "s|TARGET_DIR|$release_topdir_abs|g" "$release_topdir_abs/etc/fonts/fonts.conf.template" > $FONTCONFIG_FILE
