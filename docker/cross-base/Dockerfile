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

ENV RUSTUP_HOME=/opt/rust/rustup

ENV PATH=${PATH}:/opt/rust/cargo/bin

RUN curl https://sh.rustup.rs -sSf | RUSTUP_HOME=/opt/rust/rustup CARGO_HOME=/opt/rust/cargo bash -s -- --default-toolchain stable --profile default --no-modify-path -y

WORKDIR /work
