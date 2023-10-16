FROM yosyshq/cross-base:2.0

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
        liblzma-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        tcl-dev \
        tk-dev \
        qtbase5-dev \
        libbison-dev \
        libhidapi-dev \
        libcurl4-openssl-dev \
        libbz2-dev \
        libltdl-dev \
        libedit-dev; \
    apt -y autoremove ;\
    rm -rf /var/lib/apt/lists/*

ENV AS=/usr/bin/${CROSS_NAME}-as \
    AR=/usr/bin/${CROSS_NAME}-ar \
    CC=/usr/bin/${CROSS_NAME}-gcc \
    CPP=/usr/bin/${CROSS_NAME}-cpp \
    CXX=/usr/bin/${CROSS_NAME}-g++ \
    LD=/usr/bin/${CROSS_NAME}-ld \
    STRIP=/usr/bin/${CROSS_NAME}-strip

#RUN wget http://archive.ubuntu.com/ubuntu/pool/main/g/gobject-introspection/libgirepository1.0-dev_1.64.1-1~ubuntu20.04.1_amd64.deb && \
#    dpkg-deb -xv libgirepository1.0-dev_1.64.1-1~ubuntu20.04.1_amd64.deb / && \
#    rm -rf libgirepository1.0-dev_1.64.1-1~ubuntu20.04.1_amd64.deb && \
#    wget http://archive.ubuntu.com/ubuntu/pool/main/g/gobject-introspection/gir1.2-glib-2.0_1.64.1-1~ubuntu20.04.1_amd64.deb && \
#    dpkg-deb -xv gir1.2-glib-2.0_1.64.1-1~ubuntu20.04.1_amd64.deb / && \
#    rm -rf gir1.2-glib-2.0_1.64.1-1~ubuntu20.04.1_amd64.deb
