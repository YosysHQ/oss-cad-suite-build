FROM fedora:32

RUN dnf install -y  mingw64-libftdi \
                    mingw64-boost \
                    mingw64-pkg-config \
                    git \
                    cmake \
                    autoconf \
                    automake \
                    mingw64-tcl \
                    mingw64-readline \
                    flex \
                    bison \
                    patch \
                    mingw64-tk \
                    mingw64-xz \
                    gperf \
                    mingw64-gtk2 \
                    mingw64-qt5-qtbase \
                    binutils \
                    gcc \
                    g++ \
                    boost-devel \
                    mingw64-gmp \
                    mingw64-eigen3 \
                    mingw64-python3 \
                    mingw64-dlfcn \
                    bc \
                    rsync \
                    zlib-devel \
                    readline-devel \
                    bzip2-devel

ENV CROSS_NAME x86_64-w64-mingw32

RUN git clone --recursive https://github.com/gsauthof/pe-util && \
    cd pe-util && \
    cmake . && \
    make install -j9 

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

WORKDIR /work
