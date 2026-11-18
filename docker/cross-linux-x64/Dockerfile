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
        libgmp-dev \
        libgtk-3-dev \
        libgtk-4-dev \
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
        libudev-dev \
        libedit-dev; \
    apt -y autoremove ;\
    rm -rf /var/lib/apt/lists/* ;\
    ln -s /lib64/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3

# libusb and libftdi1 are built here instead of taken from Ubuntu. With the
# glibc 2.38+ headers of Ubuntu 26.04, strtol, strtoul and sscanf are linked
# to the GLIBC_2.38 __isoc23_* symbols, and the libusb-1.0.so.0 and
# libftdi1.so.2 that the suite ships in lib/ do not load on older systems
# (oss-cad-suite-build#217). Same sources as Ubuntu 26.04 (same sha256).
# /usr/local comes before /usr for the linker, pkg-config and ld.so, so the
# programs use these.
#  - libusb: its configure.ac defines _GNU_SOURCE, so that line is removed,
#    and pthread_setname_np, which needs it, is disabled (it only names the
#    event thread)
#  - libftdi1: gcc 15 defaults to gnu23, so it is built as gnu17
RUN set -e -x ;\
    cd /tmp ;\
    wget -nv https://github.com/libusb/libusb/releases/download/v1.0.29/libusb-1.0.29.tar.bz2 ;\
    tar xjf libusb-1.0.29.tar.bz2 ;\
    cd libusb-1.0.29 ;\
    sed -i '/^AC_DEFINE(\[_GNU_SOURCE\]/d' configure.ac ;\
    autoreconf -fi ;\
    ./configure --prefix=/usr/local --libdir=/usr/local/lib/${CROSS_NAME} ac_cv_func_pthread_setname_np=no ;\
    make -j$(nproc) install-strip ;\
    cd /tmp ;\
    wget -nv https://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.6rc1.tar.bz2 ;\
    tar xjf libftdi1-1.6rc1.tar.bz2 ;\
    cd libftdi1-1.6rc1 ;\
    cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS=-std=gnu17 \
        -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=lib/${CROSS_NAME} \
        -DBUILD_TESTS=OFF -DDOCUMENTATION=OFF -DEXAMPLES=OFF -DFTDIPP=OFF \
        -DFTDI_EEPROM=OFF -DPYTHON_BINDINGS=OFF ;\
    make -C build -j$(nproc) install/strip ;\
    ldconfig ;\
    rm -rf /tmp/libusb-1.0.29* /tmp/libftdi1-1.6rc1*

ENV AS=/usr/bin/${CROSS_NAME}-as \
    AR=/usr/bin/${CROSS_NAME}-ar \
    CC=/usr/bin/${CROSS_NAME}-gcc \
    CPP=/usr/bin/${CROSS_NAME}-cpp \
    CXX=/usr/bin/${CROSS_NAME}-g++ \
    LD=/usr/bin/${CROSS_NAME}-ld \
    STRIP=/usr/bin/${CROSS_NAME}-strip

ENV CMAKE_POLICY_VERSION_MINIMUM=3.5
ENV PIP_BREAK_SYSTEM_PACKAGES=1
