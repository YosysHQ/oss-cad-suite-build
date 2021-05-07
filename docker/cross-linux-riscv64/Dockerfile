FROM yosyshq/cross-base:1.0

ENV CROSS_NAME riscv64-linux-gnu

ENV CROSS_PREFIX /opt/${CROSS_NAME}

RUN set -e -x ;\
    apt -y update ;\
    apt -y upgrade ;\
    apt -y install \
        gcc-riscv64-linux-gnu \
        g++-riscv64-linux-gnu \
        gnat-9-riscv64-linux-gnu \
        libc6-dev-riscv64-cross; \
    echo 'deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ focal main multiverse restricted universe' > /etc/apt/sources.list ; \
    echo 'deb [arch=riscv64] http://ports.ubuntu.com/ubuntu-ports/ focal main multiverse restricted universe' >> /etc/apt/sources.list ; \
    echo 'deb [arch=riscv64] http://ports.ubuntu.com/ubuntu-ports/ focal-updates main multiverse restricted universe' >> /etc/apt/sources.list ; \
    echo 'deb [arch=riscv64] http://ports.ubuntu.com/ubuntu-ports/ focal-security main multiverse restricted universe' >> /etc/apt/sources.list ; \
    echo 'deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ focal-updates main multiverse restricted universe' >> /etc/apt/sources.list ; \
    echo 'deb [arch=amd64] http://security.ubuntu.com/ubuntu/ focal-security main multiverse restricted universe' >> /etc/apt/sources.list ; \
    dpkg --add-architecture riscv64 ;\
    apt -y update ;\
    apt -y upgrade ;\
    apt -y install \
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
        qtbase5-dev:riscv64 \
        libbison-dev:riscv64 \
        libhidapi-dev:riscv64 \
        libcurl4-openssl-dev:riscv64 \
        libbz2-dev:riscv64 \
        libllvm10:riscv64; \
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

RUN rustup target add riscv64gc-unknown-linux-gnu && \
    mkdir -p /.cargo && \
    echo "[target.riscv64gc-unknown-linux-gnu]" > /.cargo/config && \
    echo "linker = \"riscv64-linux-gnu-gcc\"" >> /.cargo/config

RUN wget http://ports.ubuntu.com/pool/main/g/gobject-introspection/libgirepository1.0-dev_1.64.1-1~ubuntu20.04.1_riscv64.deb && \
    dpkg-deb -xv libgirepository1.0-dev_1.64.1-1~ubuntu20.04.1_riscv64.deb / && \
    rm -rf libgirepository1.0-dev_1.64.1-1~ubuntu20.04.1_riscv64.deb && \
    wget http://ports.ubuntu.com/pool/main/g/gobject-introspection/gir1.2-glib-2.0_1.64.1-1~ubuntu20.04.1_riscv64.deb && \
    dpkg-deb -xv gir1.2-glib-2.0_1.64.1-1~ubuntu20.04.1_riscv64.deb / && \
    rm -rf gir1.2-glib-2.0_1.64.1-1~ubuntu20.04.1_riscv64.deb
