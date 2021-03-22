FROM yosyshq/cross-base:1.0

ENV CROSS_NAME riscv64-linux-gnu

ENV CROSS_PREFIX /opt/${CROSS_NAME}

RUN set -e -x ;\
    apt -y update ;\
    apt -y upgrade ;\
    apt -y install \
        gcc-riscv64-linux-gnu \
        g++-riscv64-linux-gnu \
        libc6-dev-riscv64-cross; \
    echo 'deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ focal main multiverse restricted universe' > /etc/apt/sources.list ; \
    echo 'deb [arch=riscv64] http://ports.ubuntu.com/ubuntu-ports/ focal main multiverse restricted universe' >> /etc/apt/sources.list ; \
    echo 'deb [arch=riscv64] http://ports.ubuntu.com/ubuntu-ports/ focal-updates main multiverse restricted universe' >> /etc/apt/sources.list ; \
    echo 'deb [arch=riscv64] http://ports.ubuntu.com/ubuntu-ports/ focal-security main multiverse restricted universe' >> /etc/apt/sources.list ; \
    echo 'deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ focal-updates main multiverse restricted universe' >> /etc/apt/sources.list ; \
    echo 'deb [arch=amd64] http://security.ubuntu.com/ubuntu/ focal-security main multiverse restricted universe' >> /etc/apt/sources.list ; \
    cat /etc/apt/sources.list ;\
    dpkg --add-architecture riscv64 ;\
    apt -y update ;\
    apt -y upgrade ;\
    apt -y install \
        libgtk2.0-0:riscv64 \
        libcups2:riscv64 \
        libqt5printsupport5:riscv64 \
        libboost-dev:riscv64 \
        libboost-filesystem-dev:riscv64 \
        libboost-thread-dev:riscv64 \
        libboost-iostreams-dev:riscv64 \
        libboost-program-options-dev:riscv64 \
        libeigen3-dev:riscv64 \
        libffi-dev:riscv64 \
        libftdi1-dev:riscv64 \
        libgmp-dev:riscv64 \
        libgtk2.0-dev:riscv64 \
        liblzma-dev:riscv64 \
        libreadline-dev:riscv64 \
        libsqlite3-dev:riscv64 \
        libssl-dev:riscv64 \
        tcl-dev:riscv64 \
        tk-dev:riscv64 \
        qtbase5-dev:riscv64 ; \
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

ENV PKG_CONFIG_PATH /usr/lib/riscv64-linux-gnu/pkgconfig
