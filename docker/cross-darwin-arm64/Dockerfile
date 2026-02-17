FROM yosyshq/cross-linux-x64:2.0 AS builder

RUN cd /tmp \
    && RUSTUP_HOME=/opt/rust/rustup CARGO_HOME=/opt/rust/cargo rustup update \
    && cargo install --git https://github.com/indygreg/apple-platform-rs --branch main --bin rcodesign apple-codesign
RUN cd /tmp \
    && git clone https://github.com/mmicko/macdylibbundler \
    && cd macdylibbundler \
    && sed -i "s,CXXFLAGS=-O2 -std=c++11,CXXFLAGS=-O2 -std=c++11 -static-libstdc++ -static-libgcc,g" Makefile \
    && make 

FROM yosyshq/cross-base:3.0

RUN set -e -x ;\
    apt -y update ;\
    apt -y upgrade ;\
    apt -y install \
        clang \
        pkgconf \
        autoconf-archive \
        libtool \
        help2man \
        python3 \
        libxml2-dev \
        libz-dev \
        liblzma-dev \
        libssl-dev; \
    apt -y autoremove ;\
    rm -rf /var/lib/apt/lists/*

# Taken from https://github.com/joseluisq/rust-linux-darwin-builder

# Mac OS X SDK version
ARG OSX_SDK_VERSION=12.3
ARG OSX_SDK_SUM=3abd261ceb483c44295a6623fdffe5d44fc4ac2c872526576ec5ab5ad0f6e26c
ARG OSX_VERSION_MIN=11.0

# OS X Cross
ARG OSX_CROSS_COMMIT=ff8d100f3f026b4ffbe4ce96d8aac4ce06f1278b

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


ENV CROSS_NAME aarch64-apple-darwin21.4

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
    echo "linker = \"aarch64-apple-darwin21.4-clang\"" >> /.cargo/config && \
    echo "ar = \"aarch64-apple-darwin21.4-ar\"" >> /.cargo/config


COPY Toolchain.cmake ${CROSS_PREFIX}/

ENV MACOSX_DEPLOYMENT_TARGET=12.0

ENV CMAKE_TOOLCHAIN_FILE ${CROSS_PREFIX}/Toolchain.cmake

ENV OSXCROSS_PKG_CONFIG_USE_NATIVE_VARIABLES=1

ENV OSXCROSS_MP_INC=1 

ENV PKG_CONFIG_PATH /opt/local/lib/pkgconfig

RUN cd /opt \
  && wget https://github.com/mmicko/macos-resources/releases/download/v3/Qt5.15.3-arm64.tar.gz \
  && tar xfz Qt5.15.3-arm64.tar.gz \
  && rm Qt5.15.3-arm64.tar.gz \
  && rm -rf /opt/Qt5.15.3/bin \
  && ln -s /usr/lib/qt5/bin /opt/Qt5.15.3/bin \
  && cd /tmp \
  && wget https://github.com/mmicko/macos-resources/releases/download/v3/macports-darwin-arm64.tar \
  && tar xf macports-darwin-arm64.tar \
  && cd / \
  && echo "Unpack atk-2.38.0_1.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/atk/atk-2.38.0_1.darwin_21.arm64.tbz2 \
  && echo "Unpack boost176-1.76.0_10+no_single.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/boost176/boost176-1.76.0_10+no_single.darwin_21.arm64.tbz2 \
  && echo "Unpack brotli-1.1.0_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/brotli/brotli-1.1.0_0.darwin_21.arm64.tbz2 \
  && echo "Unpack bzip2-1.0.8_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/bzip2/bzip2-1.0.8_0.darwin_21.arm64.tbz2 \
  && echo "Unpack cairo-1.17.6_1+quartz.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/cairo/cairo-1.17.6_1+quartz.darwin_21.arm64.tbz2 \
  && echo "Unpack curl-8.5.0_0+ssl.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/curl/curl-8.5.0_0+ssl.darwin_21.arm64.tbz2 \
  && echo "Unpack eigen3-3.4.0_1.any_any.noarch.tbz2" \
  && tar xfj /tmp/eigen3/eigen3-3.4.0_1.any_any.noarch.tbz2 \
  && echo "Unpack expat-2.5.0_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/expat/expat-2.5.0_0.darwin_21.arm64.tbz2 \
  && echo "Unpack fontconfig-2.15.0_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/fontconfig/fontconfig-2.15.0_0.darwin_21.arm64.tbz2 \
  && echo "Unpack freetype-2.13.2_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/freetype/freetype-2.13.2_0.darwin_21.arm64.tbz2 \
  && echo "Unpack fribidi-1.0.13_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/fribidi/fribidi-1.0.13_0.darwin_21.arm64.tbz2 \
  && echo "Unpack gdbm-1.23_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/gdbm/gdbm-1.23_0.darwin_21.arm64.tbz2 \
  && echo "Unpack gdk-pixbuf2-2.42.10_1.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/gdk-pixbuf2/gdk-pixbuf2-2.42.10_1.darwin_21.arm64.tbz2 \
  && echo "Unpack gettext-0.21.1_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/gettext/gettext-0.21.1_0.darwin_21.arm64.tbz2 \
  && echo "Unpack gettext-runtime-0.21.1_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/gettext-runtime/gettext-runtime-0.21.1_0.darwin_21.arm64.tbz2 \
  && echo "Unpack glib2-2.78.3_1+quartz.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/glib2/glib2-2.78.3_1+quartz.darwin_21.arm64.tbz2 \
  && echo "Unpack gmp-6.3.0_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/gmp/gmp-6.3.0_0.darwin_21.arm64.tbz2 \
  && echo "Unpack gobject-introspection-1.78.1_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/gobject-introspection/gobject-introspection-1.78.1_0.darwin_21.arm64.tbz2 \
  && echo "Unpack graphite2-1.3.14_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/graphite2/graphite2-1.3.14_0.darwin_21.arm64.tbz2 \
  && echo "Unpack gtk3-3.24.38_0+quartz.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/gtk3/gtk3-3.24.38_0+quartz.darwin_21.arm64.tbz2 \
  && echo "Unpack harfbuzz-8.3.0_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/harfbuzz/harfbuzz-8.3.0_0.darwin_21.arm64.tbz2 \
  && echo "Unpack hidapi-0.12.0_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/hidapi/hidapi-0.12.0_0.darwin_21.arm64.tbz2 \
  && echo "Unpack icu-74.1_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/icu/icu-74.1_0.darwin_21.arm64.tbz2 \
  && echo "Unpack libdeflate-1.19_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/libdeflate/libdeflate-1.19_0.darwin_21.arm64.tbz2 \
  && echo "Unpack libepoxy-1.5.10_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/libepoxy/libepoxy-1.5.10_0.darwin_21.arm64.tbz2 \
  && echo "Unpack libffi-3.4.4_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/libffi/libffi-3.4.4_0.darwin_21.arm64.tbz2 \
  && echo "Unpack libftdi1-1.5_2.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/libftdi1/libftdi1-1.5_2.darwin_21.arm64.tbz2 \
  && echo "Unpack libiconv-1.17_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/libiconv/libiconv-1.17_0.darwin_21.arm64.tbz2 \
  && echo "Unpack libjpeg-turbo-2.1.5.1_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/libjpeg-turbo/libjpeg-turbo-2.1.5.1_0.darwin_21.arm64.tbz2 \
  && echo "Unpack libpixman-0.42.2_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/libpixman/libpixman-0.42.2_0.darwin_21.arm64.tbz2 \
  && echo "Unpack libpng-1.6.40_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/libpng/libpng-1.6.40_0.darwin_21.arm64.tbz2 \
  && echo "Unpack libtool-2.4.7_1.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/libtool/libtool-2.4.7_1.darwin_21.arm64.tbz2 \
  && echo "Unpack libusb-1.0.26_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/libusb/libusb-1.0.26_0.darwin_21.arm64.tbz2 \
  && echo "Unpack mesa-22.1.7_1.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/mesa/mesa-22.1.7_1.darwin_21.arm64.tbz2 \
  && echo "Unpack ncurses-6.4_1.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/ncurses/ncurses-6.4_1.darwin_21.arm64.tbz2 \ 
  && echo "Unpack openssl-3_16.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/openssl/openssl-3_16.darwin_21.arm64.tbz2 \
  && echo "Unpack openssl3-3.2.0_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/openssl3/openssl3-3.2.0_0.darwin_21.arm64.tbz2 \
  && echo "Unpack ossp-uuid-1.6.2_13+perl5_34.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/ossp-uuid/ossp-uuid-1.6.2_13+perl5_34.darwin_21.arm64.tbz2 \
  && echo "Unpack pango-1.50.14_0+quartz.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/pango/pango-1.50.14_0+quartz.darwin_21.arm64.tbz2 \
  && echo "Unpack pcre2-10.42_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/pcre2/pcre2-10.42_0.darwin_21.arm64.tbz2 \
  && echo "Unpack readline-8.2.001_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/readline/readline-8.2.001_0.darwin_21.arm64.tbz2 \
  && echo "Unpack realpath-1.0.2_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/realpath/realpath-1.0.2_0.darwin_21.arm64.tbz2 \
  && echo "Unpack sqlite3-3.44.2_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/sqlite3/sqlite3-3.44.2_0.darwin_21.arm64.tbz2 \
  && echo "Unpack tcl-8.6.13_0+corefoundation+threads.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/tcl/tcl-8.6.13_0+corefoundation+threads.darwin_21.arm64.tbz2 \
  && echo "Unpack tiff-4.6.0_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/tiff/tiff-4.6.0_0.darwin_21.arm64.tbz2 \
  && echo "Unpack tk-8.6.13_2+quartz.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/tk/tk-8.6.13_2+quartz.darwin_21.arm64.tbz2 \
  && echo "Unpack xorg-libX11-1.8.7_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/xorg-libX11/xorg-libX11-1.8.7_0.darwin_21.arm64.tbz2 \
  && echo "Unpack xorg-libxcb-1.16_0+python311.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/xorg-libxcb/xorg-libxcb-1.16_0+python311.darwin_21.arm64.tbz2 \
  && echo "Unpack xorg-libXdamage-1.1.6_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/xorg-libXdamage/xorg-libXdamage-1.1.6_0.darwin_21.arm64.tbz2 \
  && echo "Unpack xorg-libXext-1.3.5_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/xorg-libXext/xorg-libXext-1.3.5_0.darwin_21.arm64.tbz2 \ 
  && echo "Unpack xorg-libXfixes-6.0.1_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/xorg-libXfixes/xorg-libXfixes-6.0.1_0.darwin_21.arm64.tbz2 \
  && echo "Unpack xorg-libXdmcp-1.1.4_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/xorg-libXdmcp/xorg-libXdmcp-1.1.4_0.darwin_21.arm64.tbz2 \
  && echo "Unpack xorg-libXau-1.0.11_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/xorg-libXau/xorg-libXau-1.0.11_0.darwin_21.arm64.tbz2 \
  && echo "Unpack xorg-xcb-proto-1.16.0_0+python311.darwin_any.noarch.tbz2 " \
  && tar xfj /tmp/xorg-xcb-proto/xorg-xcb-proto-1.16.0_0+python311.darwin_any.noarch.tbz2  \
  && echo "Unpack xorg-xorgproto-2023.2_0.darwin_any.noarch.tbz2" \
  && tar xfj /tmp/xorg-xorgproto/xorg-xorgproto-2023.2_0.darwin_any.noarch.tbz2 \
  && echo "Unpack xz-5.4.5_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/xz/xz-5.4.5_0.darwin_21.arm64.tbz2 \
  && echo "Unpack zlib-1.3_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/zlib/zlib-1.3_0.darwin_21.arm64.tbz2 \
  && echo "Unpack zstd-1.5.5_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/zstd/zstd-1.5.5_0.darwin_21.arm64.tbz2 \
  && echo "Unpack libidn2-2.3.4_1.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/libidn2/libidn2-2.3.4_1.darwin_21.arm64.tbz2 \
  && echo "Unpack libpsl-0.21.2-20230117_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/libpsl/libpsl-0.21.2-20230117_0.darwin_21.arm64.tbz2 \
  && echo "Unpack libunistring-1.1_0.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/libunistring/libunistring-1.1_0.darwin_21.arm64.tbz2 \
  && echo "Unpack gtk-osx-application-common-gtk3-3.0.1_2.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/gtk-osx-application-common-gtk3/gtk-osx-application-common-gtk3-3.0.1_2.darwin_21.arm64.tbz2 \
  && echo "Unpack gtk-osx-application-gtk3-3.0.1_2.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/gtk-osx-application-gtk3/gtk-osx-application-gtk3-3.0.1_2.darwin_21.arm64.tbz2 \
  && echo "Unpack lerc-4.0.0_1.darwin_21.arm64.tbz2" \
  && tar xfj /tmp/lerc/lerc-4.0.0_1.darwin_21.arm64.tbz2 \
  && echo "Cleanup" \
  && cp -r /opt/local/libexec/boost/1.76/include/* /opt/local/include/. \
  && cp /opt/local/libexec/boost/1.76/lib/* /opt/local/lib/. \
  && cp /usr/include/FlexLexer.h /opt/local/include/. \
  && cp /opt/local/share/pkgconfig/* /opt/local/lib/pkgconfig/. \  
  && cp -r /opt/local/share/cmake /tmp \
  && cp -r /opt/local/share/eigen3 /tmp \
  && cp -r /opt/local/share/gir-1.0 /tmp \
  && cp -r /opt/local/share/glib-2.0 /tmp \
  && cp -r /opt/local/share/terminfo /tmp \
  && rm -rf /opt/local/etc \
  && rm -rf /opt/local/sbin \
  && rm -rf /opt/local/share \
  && mkdir -p /opt/local/share \
  && rm -rf /tmp/*.tbz2 \
  && mv /tmp/cmake /opt/local/share \
  && mv /tmp/eigen3 /opt/local/share \
  && mv /tmp/gir-1.0 /opt/local/share \
  && mv /tmp/glib-2.0 /opt/local/share \
  && mv /tmp/terminfo /opt/local/share \
  && rm -rf /tmp/* \
  && mkdir -p /usr/local/osxcross/target/macports/pkgs/opt \
  && ln -s /opt/local /usr/local/osxcross/target/macports/pkgs/opt \
  && cp /opt/local/lib/pkgconfig/gtk-mac-integration-gtk3.pc /opt/local/lib/pkgconfig/gtk-mac-integration.pc

COPY --from=builder /tmp/macdylibbundler/dylibbundler /usr/local/bin/dylibbundler
COPY --from=builder /root/.cargo/bin/rcodesign /usr/local/bin/rcodesign
RUN chmod +x /usr/local/bin/dylibbundler
RUN chmod +x /usr/local/bin/rcodesign

RUN cp /usr/local/osxcross/target/bin/${CROSS_NAME}-otool /usr/local/osxcross/target/bin/otool \
  && cp /usr/local/osxcross/target/bin/${CROSS_NAME}-install_name_tool /usr/local/osxcross/target/bin/install_name_tool \
  && cp /usr/local/osxcross/target/bin/${CROSS_NAME}-ar /usr/local/osxcross/target/bin/ar \
  && cp /usr/local/osxcross/target/bin/${CROSS_NAME}-ranlib /usr/local/osxcross/target/bin/ranlib

COPY uname /usr/local/osxcross/target/bin/
RUN chmod +x /usr/local/osxcross/target/bin/uname

# Install just g-ir-compiler, not using apt since it adds lots more
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/g/gobject-introspection/libgirepository-1.0-1_1.72.0-1_amd64.deb && \
    dpkg-deb -xv libgirepository-1.0-1_1.72.0-1_amd64.deb / && \
    rm -rf libgirepository-1.0-1_1.72.0-1_amd64.deb && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/g/gobject-introspection/gobject-introspection_1.72.0-1_amd64.deb && \
    dpkg-deb -xv gobject-introspection_1.72.0-1_amd64.deb / && \
    rm -rf gobject-introspection_1.72.0-1_amd64.deb

RUN cd /opt/local/share/gir-1.0 &&\
    for i in *.gir; do  \
        sed -i 's|/opt/local/lib/||g' $i ; \
        sed -i 's|./gdk-pixbuf/||g' $i ; \
    done && \
    for i in *.gir; do  \
        echo $i ; \ 
        filename="${i%.*}" ; \
        g-ir-compiler $i -o /opt/local/lib/girepository-1.0/$filename.typelib --includedir /opt/local/share/gir-1.0 ; \
    done

COPY gschemas.compiled /opt/local/share/glib-2.0/schemas/
