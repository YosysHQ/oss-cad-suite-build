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
ARG OSX_VERSION_MIN=10.14

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


ENV CROSS_NAME x86_64-apple-darwin20.2

ENV CROSS_PREFIX /opt/${CROSS_NAME}

ENV AS=/usr/local/osxcross/target/bin/${CROSS_NAME}-as \
    AR=/usr/local/osxcross/target/bin/${CROSS_NAME}-ar \
    CC=/usr/local/osxcross/target/bin/${CROSS_NAME}-clang \
    CXX=/usr/local/osxcross/target/bin/${CROSS_NAME}-clang++ \
    LD=/usr/local/osxcross/target/bin/${CROSS_NAME}-ld \ 
    RANLIB=/usr/local/osxcross/target/bin/${CROSS_NAME}-ranlib \
    STRIP=/usr/local/osxcross/target/bin/${CROSS_NAME}-strip

ENV PATH /usr/local/osxcross/target/bin:$PATH

RUN rustup target add x86_64-apple-darwin && \
    mkdir -p /.cargo && \
    echo "[target.x86_64-apple-darwin]" > /.cargo/config && \
    echo "linker = \"x86_64-apple-darwin20.2-clang\"" >> /.cargo/config && \
    echo "ar = \"x86_64-apple-darwin20.2-ar\"" >> /.cargo/config


COPY Toolchain.cmake ${CROSS_PREFIX}/

ENV MACOSX_DEPLOYMENT_TARGET=10.14

ENV CMAKE_TOOLCHAIN_FILE ${CROSS_PREFIX}/Toolchain.cmake

RUN set -e -x ;\
    apt -y update ;\
    apt -y install \
        libtool \
        python3-distutils; \
    apt -y autoremove ;\
    rm -rf /var/lib/apt/lists/*

ENV OSXCROSS_MP_INC=1 

ENV PKG_CONFIG_PATH /opt/local/lib/pkgconfig

RUN cd / \
  && wget https://github.com/mmicko/macos-resources/releases/download/v1/optlocal.tgz \   
  && tar xvfz optlocal.tgz \
  && rm optlocal.tgz \
  && cp /usr/include/FlexLexer.h /opt/local/include/. \
  && cp /opt/local/share/pkgconfig/* /opt/local/lib/pkgconfig/. \
  && cp /opt/local/lib/pkgconfig/gtk-mac-integration-gtk2.pc /opt/local/lib/pkgconfig/gtk-mac-integration.pc \
  && mkdir -p /usr/local/osxcross/target/macports/pkgs/opt \
  && ln -s /opt/local /usr/local/osxcross/target/macports/pkgs/opt

RUN cd /opt \
  && wget https://github.com/mmicko/macos-resources/releases/download/v1/Qt5.12.8.tar.gz \   
  && tar xvfz Qt5.12.8.tar.gz \
  && rm Qt5.12.8.tar.gz \
  && rm -rf  /opt/Qt5.12.8/bin \
  && ln -s /usr/lib/qt5/bin /opt/Qt5.12.8/bin

COPY --from=builder /tmp/macdylibbundler/dylibbundler /usr/local/bin/dylibbundler
RUN chmod +x /usr/local/bin/dylibbundler

RUN cp /usr/local/osxcross/target/bin/x86_64-apple-darwin20.2-otool /usr/local/osxcross/target/bin/otool \
  && cp /usr/local/osxcross/target/bin/x86_64-apple-darwin20.2-install_name_tool /usr/local/osxcross/target/bin/install_name_tool \
  && cp /usr/local/osxcross/target/bin/x86_64-apple-darwin20.2-ar /usr/local/osxcross/target/bin/ar \
  && cp /usr/local/osxcross/target/bin/x86_64-apple-darwin20.2-ranlib /usr/local/osxcross/target/bin/ranlib

COPY uname /usr/local/osxcross/target/bin/
RUN chmod +x /usr/local/osxcross/target/bin/uname
