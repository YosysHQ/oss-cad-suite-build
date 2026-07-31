#!/usr/bin/env bash

DISTROS=(
  "ubuntu:16.04"
  "ubuntu:18.04"
  "ubuntu:20.04"
  "ubuntu:22.04"
  "ubuntu:24.04"
  "debian:buster"
  "debian:bullseye"
  "debian:bookworm"
  "debian:trixie"
  "fedora:30"
  "fedora:40"
  "fedora:41"
  "fedora:42"
  "almalinux:8"
  "almalinux:9"
  "almalinux:10"
  "rockylinux:8"
  "rockylinux:9"
  "centos:7"
  "opensuse/leap:15.5"
  "opensuse/leap:15.6"
  "archlinux:latest"
  "alpine:3.18"
  "alpine:3.19"
  "alpine:3.20"
  "alpine:3.21"
)

OSS_CAD="/workdir/_outputs/linux-x64/default/oss-cad-suite"
YOSYS_BIN="$OSS_CAD/bin/yosys"
SBY_BIN="$OSS_CAD/bin/sby"
SBY_TEST="$OSS_CAD/examples/demos/up_down_counter.sby"

for distro in "${DISTROS[@]}"; do
  echo -n "$distro ... "

  YOSYS=$(docker run -i --rm \
    -v "$(pwd)":/workdir \
    "$distro" \
    sh -c "
      if command -v apk >/dev/null 2>&1; then
        apk add --no-cache bash >/dev/null
      fi
      $YOSYS_BIN --version
    " 2>&1 | tr -d '\r')

  if [ ${PIPESTATUS[0]} -ne 0 ] || [ -z "$YOSYS" ]; then
    echo "YOSYS FAIL"
    continue
  fi

  SBY_OUTPUT=$(docker run -i --rm \
    -v "$(pwd)":/workdir \
    "$distro" \
    sh -c "
      if command -v apk >/dev/null 2>&1; then
        apk add --no-cache bash >/dev/null
      fi
      cd /workdir &&
      $SBY_BIN -f $SBY_TEST
    " 2>&1)

  if echo "$SBY_OUTPUT" | grep "DONE (PASS" >/dev/null; then
    SBY_STATUS="PASS"
  else
    SBY_STATUS="FAIL"
    echo "$SBY_OUTPUT" | tail -20
  fi

  echo -e "$SBY_STATUS\t$YOSYS"
done
