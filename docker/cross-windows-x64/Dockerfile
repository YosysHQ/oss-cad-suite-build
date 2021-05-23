FROM fedora:32

RUN dnf install -y  mingw64-libftdi \
                    mingw64-boost \
                    mingw64-pkg-config \
                    mingw64-tcl \
                    mingw64-readline \
                    mingw64-tk \
                    mingw64-xz \
                    mingw64-gtk3 \
                    mingw64-qt5-qtbase \
                    mingw64-eigen3 \
                    mingw64-dlfcn \
                    mingw64-hidapi \
                    mingw64-bzip2 \
                    mingw64-curl \
                    git \
                    cmake \
                    autoconf \
                    automake \
                    flex \
                    bison \
                    patch \
                    gperf \
                    binutils \
                    gcc \
                    g++ \
                    bc \
                    rsync \
                    python3 \
                    which \
                    libtool \
                    libtool-ltdl-devel \
                    diffutils \
                    java-11-openjdk-headless \
                    cpio \
                    xz

ENV CROSS_NAME x86_64-w64-mingw32

ENV AS=/usr/bin/${CROSS_NAME}-as \
    AR=/usr/bin/${CROSS_NAME}-ar \
    CC=/usr/bin/${CROSS_NAME}-gcc \
    CPP=/usr/bin/${CROSS_NAME}-cpp \
    CXX=/usr/bin/${CROSS_NAME}-g++ \
    LD=/usr/bin/${CROSS_NAME}-ld \
    STRIP=/usr/bin/${CROSS_NAME}-strip

ENV PKG_CONFIG_PATH /usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig

ENV CROSS_PREFIX /opt/${CROSS_NAME}

RUN cp /usr/include/FlexLexer.h /usr/x86_64-w64-mingw32/sys-root/mingw/include/.

RUN cp /usr/x86_64-w64-mingw32/sys-root/mingw/lib/libpthread.dll.a  /usr/x86_64-w64-mingw32/sys-root/mingw/lib/libpthread.a

COPY Toolchain.cmake ${CROSS_PREFIX}/

ENV CMAKE_TOOLCHAIN_FILE ${CROSS_PREFIX}/Toolchain.cmake

ENV RUSTUP_HOME /opt/rust/rustup

ENV PATH ${PATH}:/opt/rust/cargo/bin

RUN curl https://sh.rustup.rs -sSf | RUSTUP_HOME=/opt/rust/rustup CARGO_HOME=/opt/rust/cargo bash -s -- --default-toolchain stable --profile default --no-modify-path -y

RUN rustup target add x86_64-pc-windows-gnu && \
    mkdir -p /.cargo && \
    echo "[target.x86_64-pc-windows-gnu]" > /.cargo/config && \
    echo "linker = \"x86_64-w64-mingw32-gcc\"" >> /.cargo/config && \
    echo "ar = \"x86_64-w64-mingw32-ar\"" >> /.cargo/config

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN cd /tmp \
    && curl -L  https://download-ib01.fedoraproject.org/pub/fedora/linux/releases/33/Everything/source/tree/Packages/m/mingw-gmp-6.1.2-9.fc33.src.rpm --output mingw-gmp-6.1.2-9.fc33.src.rpm \
    && rpm2cpio mingw-gmp-6.1.2-9.fc33.src.rpm | cpio -idmv \
    && tar -xf gmp-6.1.2.tar.xz \
    && cd gmp-6.1.2 \
    && mingw64-configure --disable-shared --enable-cxx --enable-static \
    && mingw64-make -j9 \
    && mingw64-make install \
    && curl http://ftp.gnu.org/gnu/bison/bison-3.5.tar.gz --output /tmp/bison-3.5.tar.gz \
    && curl -L https://raw.githubusercontent.com/reactos/RosBE/master/Patches/bison-3.5-reactos-fix-win32-build.patch --output /tmp/bison.patch \
    && cd /tmp \
    && tar -xzf bison-3.5.tar.gz \
    && cd bison-3.5 \
    && patch -p1 < /tmp/bison.patch \
    && mingw64-configure \
    && mingw64-make -j9 \
    && mingw64-make install \
    && rm -rf /tmp/* \
    && true

COPY winsock2.h /usr/x86_64-w64-mingw32/sys-root/mingw/include/

WORKDIR /work

#RUN dnf install -y python3-cairo python3-cairo-devel
