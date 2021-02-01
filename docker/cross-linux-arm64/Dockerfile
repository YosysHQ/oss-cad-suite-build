FROM yosyshq/cross-base:1.0

ENV CROSS_NAME aarch64-linux-gnu

ENV CROSS_PREFIX /opt/${CROSS_NAME}

RUN set -e -x ;\
    apt -y update ;\
    apt -y upgrade ;\
    apt -y install \
        gcc-aarch64-linux-gnu \
        g++-aarch64-linux-gnu \
        libc6-dev-arm64-cross; \
    echo 'deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ focal main multiverse restricted universe' > /etc/apt/sources.list ; \
    echo 'deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ focal main multiverse restricted universe' >> /etc/apt/sources.list ; \
    echo 'deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ focal-updates main multiverse restricted universe' >> /etc/apt/sources.list ; \
    echo 'deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ focal-security main multiverse restricted universe' >> /etc/apt/sources.list ; \
    echo 'deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ focal-updates main multiverse restricted universe' >> /etc/apt/sources.list ; \
    echo 'deb [arch=amd64] http://security.ubuntu.com/ubuntu/ focal-security main multiverse restricted universe' >> /etc/apt/sources.list ; \
    dpkg --add-architecture arm64 ;\
    apt -y update ;\
    apt -y upgrade ;\
    apt -y install \
        libboost-dev:arm64 \
        libboost-filesystem-dev:arm64 \
        libboost-thread-dev:arm64 \
        libboost-iostreams-dev:arm64 \
        libboost-program-options-dev:arm64 \
        libeigen3-dev:arm64 \
        libffi-dev:arm64 \
        libftdi1-dev:arm64 \
        libgmp-dev:arm64 \
        libgtk2.0-dev:arm64 \
        liblzma-dev:arm64 \
        libreadline-dev:arm64 \
        libsqlite3-dev:arm64 \
        libssl-dev:arm64 \
        tcl-dev:arm64 \
        tk-dev:arm64 \
        qtbase5-dev:arm64 ; \
    apt -y autoremove ;\
    rm -rf /var/lib/apt/lists/*

ENV AS=/usr/bin/${CROSS_NAME}-as \
    AR=/usr/bin/${CROSS_NAME}-ar \
    CC=/usr/bin/${CROSS_NAME}-gcc \
    CPP=/usr/bin/${CROSS_NAME}-cpp \
    CXX=/usr/bin/${CROSS_NAME}-g++ \
    LD=/usr/bin/${CROSS_NAME}-ld \
    STRIP=/usr/bin/${CROSS_NAME}-strip

COPY Toolchain.cmake ${CROSS_PREFIX}/

ENV CMAKE_TOOLCHAIN_FILE ${CROSS_PREFIX}/Toolchain.cmake

ENV PKG_CONFIG_PATH /usr/lib/aarch64-linux-gnu/pkgconfig
