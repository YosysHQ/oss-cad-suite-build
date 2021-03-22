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
        default-jdk; \
    apt -y autoremove ;\
    rm -rf /var/lib/apt/lists/*

WORKDIR /work
