FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

RUN set -e -x ;\
    apt -y update ;\
    apt -y upgrade ;\
    apt -y install \
        bc \
        unzip \
        rsync \
        bison \
        flex \
        gawk \
        git \
        pkg-config \
        python3 \
        python3-pip \
        pandoc \
        adwaita-icon-theme-full \
        cmake \
        wget \
        gperf \
        autoconf \
        curl \
        pax-utils \
        qmake6 \
        qt6-base-dev-tools \
        libtool \
        help2man \
        llvm \
        cmake \
        meson \
        ninja-build \
        default-jre-headless; \
    apt -y autoremove ;\
    rm -rf /var/lib/apt/lists/*

ENV RUSTUP_HOME=/opt/rust/rustup \
	CARGO_HOME=/opt/rust/cargo \
	PATH=/opt/rust/cargo/bin:${PATH}

RUN set -eux; \
	curl -sSf https://sh.rustup.rs | bash -s -- \
		--default-toolchain stable \
		--profile default \
		--no-modify-path \
		-y; \
	rustup toolchain install nightly; \
    chmod -R a+rwX /opt/rust/rustup /opt/rust/cargo; \
    printf '%s\n' \
    '#!/bin/sh' \
    'echo "macdeployqt not available in this Qt installation"' \
    'exit 1' \
    > /usr/lib/qt6/bin/macdeployqt && \
    chmod +x /usr/lib/qt6/bin/macdeployqt


WORKDIR /work
