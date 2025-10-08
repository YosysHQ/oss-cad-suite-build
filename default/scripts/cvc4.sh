if [ -z "$__BASH500_BOOTSTRAPPED" ]; then
  set -eu

  export __BASH500_BOOTSTRAPPED=1
  : "${BASH_500_PREFIX:="$(mktemp -d /tmp/bash-5.0.XXXXXXXX)"}"
  : "${BASH_500_VERSION:=5.0}"
  : "${BASH_500_TARBALL:=bash-${BASH_500_VERSION}.tar.gz}"
  : "${BASH_500_URL:=https://ftp.gnu.org/gnu/bash/${BASH_500_TARBALL}}"

  if command -v apt-get >/dev/null 2>&1 && [ "$(id -u)" -eq 0 ]; then
    apt-get update -y >/dev/null 2>&1 || true
    apt-get install -y build-essential wget curl libncurses-dev >/dev/null 2>&1 || true
  fi

  tmpbuild="$(mktemp -d /tmp/bash-5.0-src.XXXXXXXX)"
  (
    set -e
    cd "$tmpbuild"
    if command -v wget >/dev/null 2>&1; then
      wget -q "$BASH_500_URL"
    else
      curl -fsSL -o "$BASH_500_TARBALL" "$BASH_500_URL"
    fi
    tar xzf "$BASH_500_TARBALL"
    cd "bash-${BASH_500_VERSION}"
    ./configure --prefix="$BASH_500_PREFIX" >/dev/null
    make -j"$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1)" >/dev/null
    make install >/dev/null
  )
  rm -rf "$tmpbuild"

  exec env \
    BASH_500_PREFIX="$BASH_500_PREFIX" \
    __BASH500_CLEANUP=1 \
    PATH="$BASH_500_PREFIX/bin:$PATH" \
    "$BASH_500_PREFIX/bin/bash" "$0" "$@"
fi

if [ -n "${__BASH500_CLEANUP:-}" ]; then
  trap 'rm -rf -- "$BASH_500_PREFIX" >/dev/null 2>&1 || true' EXIT
  export PATH="$BASH_500_PREFIX/bin:$PATH"
fi

cd cvc4
export MACHINE_TYPE=x86_64
if [ "${ARCH_BASE}" != 'windows' ]; then
    sed -i -re 's,rm -rf src/antlr3debughandlers.c \&\& touch src/antlr3debughandlers.c,rm -rf src/antlr3debughandlers.c \&\& touch src/antlr3debughandlers.c \&\& cp  /usr/share/misc/config.* . ,g' ./contrib/get-antlr-3.4
else
    sed -i 's,#!/usr/bin/env bash,#!/usr/bin/env bash\nshopt -u patsub_replacement,g' src/expr/mkmetakind
    sed -i 's,#include <iosfwd>,#include <iosfwd>\n#include <cstdint>,g' src/expr/metakind_template.h
    sed -i 's,#include <string>,#include <string>\n#include <cstdint>,g' src/api/cvc4cpp.h
fi

ANTLR_CONFIGURE_ARGS="--host=${CROSS_NAME} --build=$(gcc -dumpmachine)" ./contrib/get-antlr-3.4

git clone https://github.com/uiri/toml.git
export PYTHONPATH="$PYTHONPATH:$(pwd)/toml"

if [ "${ARCH_BASE}" = 'windows' ]; then
    export CMAKE_TOOLCHAIN_FILE="${PATCHES_DIR}/Toolchain-mingw64.cmake"
    sed -i -re 's,cmake \"\$root_dir\" \$cmake_opts,cmake \"\$root_dir\" \$cmake_opts -DCMAKE_TOOLCHAIN_FILE=\$\{CMAKE_TOOLCHAIN_FILE\} -DCVC4_WINDOWS_BUILD=TRUE,g' configure.sh
else
    sed -i -re 's,cmake \"\$root_dir\" \$cmake_opts,cmake \"\$root_dir\" \$cmake_opts -DCMAKE_TOOLCHAIN_FILE=\$\{CMAKE_TOOLCHAIN_FILE\},g' configure.sh
fi

CXXFLAGS=-fPIC CFLAGS=-fPIC ./configure.sh --static --no-static-binary --prefix="${INSTALL_PREFIX}" --no-unit-testing
cd build
make "DESTDIR=${OUTPUT_DIR}" -j"${NPROC}"
make "DESTDIR=${OUTPUT_DIR}" install
cd ..
mkdir -p "${OUTPUT_DIR}/dev" "${OUTPUT_DIR}/dev/build"
cp -r src "${OUTPUT_DIR}/dev/."
cp -r build/src "${OUTPUT_DIR}/dev/build/."
rm -rf "${OUTPUT_DIR}${INSTALL_PREFIX}/include"
rm -rf "${OUTPUT_DIR}${INSTALL_PREFIX}/lib"
