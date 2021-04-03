FROM yosyshq/cross-base:1.0

ENV CROSS_NAME x86_64-linux-gnu

ENV CROSS_PREFIX /opt/${CROSS_NAME}

RUN set -e -x ;\
    apt -y update ;\
    apt -y upgrade ;\
    apt -y install \
        gcc \
        g++ \
        clang \
        gnat \
        graphviz \
        libboost-dev \
        libboost-filesystem-dev \
        libboost-thread-dev \
        libboost-iostreams-dev \
        libboost-program-options-dev \
        libeigen3-dev \
        libffi-dev \
        libftdi1-dev \
        libgmp-dev \
        libgtk2.0-dev \
        liblzma-dev \
        libsqlite3-dev \
        libssl-dev \
        tcl-dev \
        tk-dev \
        qtbase5-dev \
        libbison-dev \
        python3-dev \
        libhidapi-dev; \
    apt -y autoremove ;\
    rm -rf /var/lib/apt/lists/*

ENV AS=/usr/bin/${CROSS_NAME}-as \
    AR=/usr/bin/${CROSS_NAME}-ar \
    CC=/usr/bin/${CROSS_NAME}-gcc \
    CPP=/usr/bin/${CROSS_NAME}-cpp \
    CXX=/usr/bin/${CROSS_NAME}-g++ \
    LD=/usr/bin/${CROSS_NAME}-ld \
    STRIP=/usr/bin/${CROSS_NAME}-strip

RUN wget http://archive.ubuntu.com/ubuntu/pool/main/g/gobject-introspection/libgirepository1.0-dev_1.64.1-1~ubuntu20.04.1_amd64.deb && \
    dpkg-deb -xv libgirepository1.0-dev_1.64.1-1~ubuntu20.04.1_amd64.deb / && \
    rm -rf libgirepository1.0-dev_1.64.1-1~ubuntu20.04.1_amd64.deb
