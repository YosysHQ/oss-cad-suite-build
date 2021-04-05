FROM ubuntu:20.04

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
        python \
        python3 \
        cmake \
        wget \
        gperf \
        autoconf \
        curl \
        pax-utils \
        qt5-qmake \
        qtbase5-dev-tools \
        libz-dev \
        libreadline-dev \
        llvm; \        
    apt -y autoremove ;\
    rm -rf /var/lib/apt/lists/*

RUN cd /usr/local && \
    wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" https://javadl.oracle.com/webapps/download/GetFile/1.8.0_281-b09/89d678f2be164786b292527658ca1605/linux-i586/jre-8u281-linux-x64.tar.gz && \
    tar xvfz jre-8u281-linux-x64.tar.gz --strip-components 1 && \
    rm -rf jre-8u281-linux-x64.tar.gz

ENV RUSTUP_HOME /opt/rust/rustup

ENV PATH ${PATH}:/opt/rust/cargo/bin

RUN curl https://sh.rustup.rs -sSf | RUSTUP_HOME=/opt/rust/rustup CARGO_HOME=/opt/rust/cargo bash -s -- --default-toolchain stable --profile default --no-modify-path -y

WORKDIR /work
