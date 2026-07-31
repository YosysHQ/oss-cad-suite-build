#!/usr/bin/env bash

set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 <target> <command> [args...]"
    echo "Example: $0 linux-x64 ./build.sh"
    exit 1
fi

TARGET="$1"
shift

docker run --rm -it \
    -v "$(pwd)":/work \
    "yosyshq/cross-${TARGET}:4.0" \
    "$@"
