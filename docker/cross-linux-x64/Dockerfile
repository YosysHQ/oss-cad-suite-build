FROM yosyshq/cross-base:4.0

ENV CROSS_NAME=x86_64-linux-gnu

ENV CROSS_PREFIX=/opt/${CROSS_NAME}

RUN set -e -x ;\
    apt -y update ;\
    apt -y upgrade ;\
    apt -y install \
        lsb-release \
        wget \
        software-properties-common \
        gnupg \
        gcc \
        g++ \
        clang \
        gnat \
        python3-dev \
        libboost-dev \
        libboost-filesystem-dev \
        libboost-thread-dev \
        libboost-iostreams-dev \
        libboost-program-options-dev \
        libeigen3-dev \
        libffi-dev \
        libftdi1-dev \
        libgmp-dev \
        libgtk-3-dev \
        libjudy-dev \
        libgirepository1.0-dev \
        libjson-glib-dev \
        desktop-file-utils \
        liblzma-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        tcl-dev \
        tk-dev \
        qt6-base-dev \
        libbison-dev \
        libhidapi-dev \
        libcurl4-openssl-dev \
        libbz2-dev \
        libltdl-dev \
        libmpfr-dev \
        libedit-dev; \
    apt -y autoremove ;\
    rm -rf /var/lib/apt/lists/* ;\
    ln -s /lib64/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3

ENV AS=/usr/bin/${CROSS_NAME}-as \
    AR=/usr/bin/${CROSS_NAME}-ar \
    CC=/usr/bin/${CROSS_NAME}-gcc \
    CPP=/usr/bin/${CROSS_NAME}-cpp \
    CXX=/usr/bin/${CROSS_NAME}-g++ \
    LD=/usr/bin/${CROSS_NAME}-ld \
    STRIP=/usr/bin/${CROSS_NAME}-strip

ENV CMAKE_POLICY_VERSION_MINIMUM=3.5
ENV PIP_BREAK_SYSTEM_PACKAGES=1
