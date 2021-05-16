FROM fedora:33

RUN dnf install -y  mingw64-libftdi \
                    mingw64-boost \
                    mingw64-pkg-config \
                    mingw64-tcl \
                    mingw64-readline \
                    mingw64-tk \
                    mingw64-xz \
                    mingw64-gtk2 \
                    mingw64-qt5-qtbase \
                    mingw64-gmp \
                    mingw64-eigen3 \
                    mingw64-dlfcn \
                    mingw64-hidapi \
                    mingw64-bzip2 \
                    mingw64-curl \
                    mingw64-llvm \
                    mingw64-llvm-static \
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
                    boost-devel \
                    bc \
                    rsync \
                    python3 \
                    python3.8 \
                    which \
                    libtool \
                    diffutils

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

RUN ln -s /usr/bin/python3 /usr/bin/python

#RUN curl -L https://github.com/mmicko/fedora-ada/releases/download/v1/mingw64-gcc-10.2.1-2.fc33.x86_64.rpm --output /tmp/mingw64-gcc-10.2.1-2.fc33.x86_64.rpm && \
#    curl -L https://github.com/mmicko/fedora-ada/releases/download/v1/mingw64-gcc-gnat-10.2.1-2.fc33.x86_64.rpm --output /tmp/mingw64-gcc-gnat-10.2.1-2.fc33.x86_64.rpm && \
#    dnf reinstall -y /tmp/mingw64-gcc-10.2.1-2.fc33.x86_64.rpm && \
#    dnf localinstall -y /tmp/mingw64-gcc-gnat-10.2.1-2.fc33.x86_64.rpm && \ 
#    rm -rf /tmp/*.rpm && \
RUN cp /usr/x86_64-w64-mingw32/sys-root/mingw/lib/libLLVM* /usr/x86_64-w64-mingw32/lib/. && \
    touch /usr/x86_64-w64-mingw32/sys-root/mingw/lib/librt.a

RUN dnf install -y java-11-openjdk-headless cpio xz \
    && curl -L  https://download-ib01.fedoraproject.org/pub/fedora/linux/releases/33/Everything/source/tree/Packages/m/mingw-gmp-6.1.2-9.fc33.src.rpm --output mingw-gmp-6.1.2-9.fc33.src.rpm \
    && rpm2cpio mingw-gmp-6.1.2-9.fc33.src.rpm | cpio -idmv \
    && tar -xf gmp-6.1.2.tar.xz \
    && cd gmp-6.1.2 \
    && mingw64-configure --disable-shared --enable-cxx \
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

WORKDIR /work
