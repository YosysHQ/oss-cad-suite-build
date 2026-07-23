FROM fedora:43

RUN dnf install -y  mingw64-gcc \
                    mingw64-gcc-c++ \
                    mingw64-libftdi \
                    mingw64-boost \
                    mingw64-pkg-config \
                    mingw64-tcl \
                    mingw64-readline \
                    mingw64-tk \
                    mingw64-xz \
                    mingw64-gtk3 \
                    mingw64-qt6-qtbase \
                    mingw64-eigen3 \
                    mingw64-dlfcn \
                    mingw64-hidapi \
                    mingw64-bzip2 \
                    mingw64-curl \
                    git \
                    cmake \
                    autoconf \
                    autoconf-archive \
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
                    java-latest-openjdk-headless \
                    cpio \
                    help2man \
                    wget \
                    boost-devel \
                    meson \
                    ninja-build \
                    pandoc; \
    dnf -y autoremove && \
    dnf clean all && \
    rm -rf /var/cache/dnf

RUN set -eux; \
    tmpdir=$(mktemp -d); \
    cd "$tmpdir"; \
    git clone --recursive https://github.com/gsauthof/pe-util; \
    cd pe-util; \
    CC=gcc CXX=g++ LD=g++ cmake .; \
    make install -j9; \
    cd /; \
    rm -rf "$tmpdir"

ENV CROSS_NAME=x86_64-w64-mingw32

ENV CROSS_PREFIX=/opt/${CROSS_NAME}

ENV AS=/usr/bin/${CROSS_NAME}-as \
    AR=/usr/bin/${CROSS_NAME}-ar \
    CC=/usr/bin/${CROSS_NAME}-gcc \
    CPP=/usr/bin/${CROSS_NAME}-cpp \
    CXX=/usr/bin/${CROSS_NAME}-g++ \
    LD=/usr/bin/${CROSS_NAME}-ld \
    STRIP=/usr/bin/${CROSS_NAME}-strip \
    PKG_CONFIG_PATH=/usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig

RUN cp /usr/include/FlexLexer.h /usr/x86_64-w64-mingw32/sys-root/mingw/include/.

COPY Toolchain.cmake ${CROSS_PREFIX}/

ENV CMAKE_TOOLCHAIN_FILE=${CROSS_PREFIX}/Toolchain.cmake

ENV RUSTUP_HOME=/opt/rust/rustup \
	CARGO_HOME=/opt/rust/cargo \
	PATH=/opt/rust/cargo/bin:${PATH}

RUN set -eux; \
	curl -sSf https://sh.rustup.rs | bash -s -- \
		--default-toolchain stable \
		--profile default \
		--no-modify-path \
		-y; \
	rustup toolchain install nightly; \
    rustup target add --toolchain stable x86_64-pc-windows-gnu; \
    rustup target add --toolchain nightly x86_64-pc-windows-gnu; \
    chmod -R a+rwX /opt/rust/rustup /opt/rust/cargo; \
    mkdir -p /.cargo && \
    echo "[target.x86_64-pc-windows-gnu]" > /.cargo/config && \
    echo "linker = \"x86_64-w64-mingw32-gcc\"" >> /.cargo/config && \
    echo "ar = \"x86_64-w64-mingw32-ar\"" >> /.cargo/config

COPY tcl.pc /usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig/tcl.pc
COPY readline.pc /usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig/readline.pc
RUN for f in /usr/x86_64-w64-mingw32/sys-root/mingw/lib/libboost_*.dll.a; do \
        ln -sf "$(basename "$f")" "${f%.dll.a}.a"; \
    done

RUN cd /tmp && \
    wget https://gmplib.org/download/gmp/gmp-6.3.0.tar.xz && \
    tar -xf gmp-6.3.0.tar.xz && \
    cd gmp-6.3.0 && \
    sed -i 's|^void g(){}$|void g(int,t1 const*,t1,t2,t1 const*,int){}|' acinclude.m4 && \
    autoconf &&  \
    ./configure \
    --host=x86_64-w64-mingw32 \
    --prefix=/usr/x86_64-w64-mingw32/sys-root/mingw \
    --enable-static \
    --enable-cxx \
    --disable-shared \
    --with-pic && \
    make -j$(nproc) && \
    sudo make install && \
    cd /tmp && \
    wget https://www.mpfr.org/mpfr-4.2.1/mpfr-4.2.1.tar.xz && \
    tar xf mpfr-4.2.1.tar.xz && \
    cd mpfr-4.2.1 && \
    ./configure \
    --host=x86_64-w64-mingw32 \
    --prefix=/usr/x86_64-w64-mingw32/sys-root/mingw \
    --disable-shared \
    --enable-static \
    --with-gmp=/usr/x86_64-w64-mingw32/sys-root/mingw && \
    make -j$(nproc) && \
    sudo make install && \
    curl https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.gz --output /tmp/bison-3.8.2.tar.gz && \
    cd /tmp && \
    tar -xzf bison-3.8.2.tar.gz && \
    cd bison-3.8.2 && \
    mingw64-configure && \
    mingw64-make -j9 && \
    mingw64-make install && \
    rm -rf /tmp/*

RUN sed -i '/#include <sha512intrin.h>/s/^/#if 0\n/; /#include <sha512intrin.h>/a #endif' /usr/lib/gcc/x86_64-w64-mingw32/15.2.1/include/immintrin.h

ENV CMAKE_POLICY_VERSION_MINIMUM=3.5
ENV PIP_BREAK_SYSTEM_PACKAGES=1

WORKDIR /work
