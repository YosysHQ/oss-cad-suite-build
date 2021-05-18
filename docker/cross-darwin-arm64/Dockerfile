FROM yosyshq/cross-linux-x64:1.0 AS builder

RUN cd /tmp \
    && git clone https://github.com/auriamg/macdylibbundler \
    && cd macdylibbundler \
    && sed -i "s,CXXFLAGS=-O2 -std=c++11,CXXFLAGS=-O2 -std=c++11 -static-libstdc++ -static-libgcc,g" Makefile \
    && make 

FROM yosyshq/cross-base:1.0

RUN set -e -x ;\
    apt -y update ;\
    apt -y upgrade ;\
    apt -y install \
        clang \
        pkgconf \
        libtool \
        python3-distutils \
        libxml2-dev \
        libz-dev \
        liblzma-dev \
        libssl-dev; \
    apt -y autoremove ;\
    rm -rf /var/lib/apt/lists/*

# Taken from https://github.com/joseluisq/rust-linux-darwin-builder

# Mac OS X SDK version
ARG OSX_SDK_VERSION=11.1
ARG OSX_SDK_SUM=97a916b0b68aae9dcd32b7d12422ede3e5f34db8e169fa63bfb18ec410b8f5d9
ARG OSX_VERSION_MIN=11.0

# OS X Cross
ARG OSX_CROSS_COMMIT=8a716a43a72dab1db9630d7824ee0af3730cb8f9

# Install OS X Cross
# A Mac OS X cross toolchain for Linux, FreeBSD, OpenBSD and Android

RUN set -eux \
    && echo "Cloning osxcross..." \
    && git clone https://github.com/tpoechtrager/osxcross.git /usr/local/osxcross \
    && cd /usr/local/osxcross \
    && git checkout -q "${OSX_CROSS_COMMIT}" \
    && rm -rf ./.git \
    && true

RUN set -eux \
    && echo "Building osxcross with ${OSX_SDK_VERSION}..." \
    && cd /usr/local/osxcross \
    && curl -Lo "./tarballs/MacOSX${OSX_SDK_VERSION}.sdk.tar.xz" \
        "https://github.com/joseluisq/macosx-sdks/releases/download/${OSX_SDK_VERSION}/MacOSX${OSX_SDK_VERSION}.sdk.tar.xz" \
    && echo "${OSX_SDK_SUM}  ./tarballs/MacOSX${OSX_SDK_VERSION}.sdk.tar.xz" \
        | sha256sum -c - \
    && env UNATTENDED=yes OSX_VERSION_MIN=${OSX_VERSION_MIN} ./build.sh \
    && rm -rf *~ taballs *.tar.xz \
    && rm -rf /tmp/* \
    && true


ENV CROSS_NAME aarch64-apple-darwin20.2

ENV CROSS_PREFIX /opt/${CROSS_NAME}

ENV AS=/usr/local/osxcross/target/bin/${CROSS_NAME}-as \
    AR=/usr/local/osxcross/target/bin/${CROSS_NAME}-ar \
    CC=/usr/local/osxcross/target/bin/${CROSS_NAME}-clang \
    CXX=/usr/local/osxcross/target/bin/${CROSS_NAME}-clang++ \
    LD=/usr/local/osxcross/target/bin/${CROSS_NAME}-ld \ 
    RANLIB=/usr/local/osxcross/target/bin/${CROSS_NAME}-ranlib \
    STRIP=/usr/local/osxcross/target/bin/${CROSS_NAME}-strip

ENV PATH /usr/local/osxcross/target/bin:$PATH

RUN rustup target add aarch64-apple-darwin && \
    mkdir -p /.cargo && \
    echo "[target.aarch64-apple-darwin]" > /.cargo/config && \
    echo "linker = \"aarch64-apple-darwin20.2-clang\"" >> /.cargo/config && \
    echo "ar = \"aarch64-apple-darwin20.2-ar\"" >> /.cargo/config


COPY Toolchain.cmake ${CROSS_PREFIX}/

ENV CMAKE_TOOLCHAIN_FILE ${CROSS_PREFIX}/Toolchain.cmake

ENV OSXCROSS_MP_INC=1 

ENV PKG_CONFIG_PATH /opt/local/lib/pkgconfig

COPY --from=builder /tmp/macdylibbundler/dylibbundler /usr/local/bin/dylibbundler
RUN chmod +x /usr/local/bin/dylibbundler

RUN cp /usr/local/osxcross/target/bin/x86_64-apple-darwin20.2-otool /usr/local/osxcross/target/bin/otool \
  && cp /usr/local/osxcross/target/bin/x86_64-apple-darwin20.2-install_name_tool /usr/local/osxcross/target/bin/install_name_tool \
  && cp /usr/local/osxcross/target/bin/x86_64-apple-darwin20.2-ar /usr/local/osxcross/target/bin/ar \
  && cp /usr/local/osxcross/target/bin/x86_64-apple-darwin20.2-ranlib /usr/local/osxcross/target/bin/ranlib

COPY uname /usr/local/osxcross/target/bin/
RUN chmod +x /usr/local/osxcross/target/bin/uname

ENV MACOSX_DEPLOYMENT_TARGET=11.0

RUN sed 's|ARCH="x86_64"|ARCH="arm64"|g' -i /usr/local/osxcross/target/bin/osxcross-macports &&\
    yes 1 | osxcross-macports --select-mirror && \
    osxcross-macports install libusb gmp && \
    ln -s /usr/local/osxcross/target/macports/pkgs/opt/local /opt/local
