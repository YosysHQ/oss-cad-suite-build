FROM yosyshq/cross-base:4.0 AS builder

RUN cd /tmp \
    && cargo install --git https://github.com/indygreg/apple-platform-rs --branch main --bin rcodesign apple-codesign
RUN cd /tmp \
    && git clone https://github.com/mmicko/macdylibbundler \
    && cd macdylibbundler \
    && sed -i "s,CXXFLAGS=-O2 -std=c++11,CXXFLAGS=-O2 -std=c++11 -static-libstdc++ -static-libgcc,g" Makefile \
    && make 

FROM yosyshq/cross-base:4.0

COPY --from=builder /tmp/macdylibbundler/dylibbundler /usr/local/bin/dylibbundler
COPY --from=builder /opt/rust/cargo/bin/rcodesign /usr/local/bin/rcodesign
RUN chmod +x /usr/local/bin/dylibbundler
RUN chmod +x /usr/local/bin/rcodesign

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
ARG OSX_SDK_VERSION=26.5
ARG OSX_SDK_SUM=c573b2fa59601ce016595074f401ec99f82bbf571c053b935f2a52fa3332d60b
ARG OSX_VERSION_MIN=11.0

# OS X Cross
ARG OSX_CROSS_COMMIT=c412eacb56d81072d4d2eaf7251a2de9d9a28f7f

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
        "https://github.com/mmicko/macos-resources/releases/download/v4/MacOSX${OSX_SDK_VERSION}.sdk.tar.xz" \
    && echo "${OSX_SDK_SUM}  ./tarballs/MacOSX${OSX_SDK_VERSION}.sdk.tar.xz" \
        | sha256sum -c - \
    && env UNATTENDED=yes OSX_VERSION_MIN=${OSX_VERSION_MIN} ./build.sh \
    && find /usr/local/osxcross -mindepth 1 -maxdepth 1 ! -name target -exec rm -rf {} + \
    && rm -rf /tmp/* \
    && true

ENV CROSS_NAME=aarch64-apple-darwin25.5

ENV CROSS_PREFIX=/opt/${CROSS_NAME}

ENV AS=/usr/local/osxcross/target/bin/${CROSS_NAME}-as \
    AR=/usr/local/osxcross/target/bin/${CROSS_NAME}-ar \
    CC=/usr/local/osxcross/target/bin/${CROSS_NAME}-clang \
    CXX=/usr/local/osxcross/target/bin/${CROSS_NAME}-clang++ \
    LD=/usr/local/osxcross/target/bin/${CROSS_NAME}-ld \ 
    RANLIB=/usr/local/osxcross/target/bin/${CROSS_NAME}-ranlib \
    STRIP=/usr/local/osxcross/target/bin/${CROSS_NAME}-strip \
    PKG_CONFIG_PATH=/opt/local/lib/pkgconfig \
    PATH=/usr/local/osxcross/target/bin:$PATH

RUN cp /usr/local/osxcross/target/bin/${CROSS_NAME}-otool /usr/local/osxcross/target/bin/otool \
  && cp /usr/local/osxcross/target/bin/${CROSS_NAME}-install_name_tool /usr/local/osxcross/target/bin/install_name_tool \
  && cp /usr/local/osxcross/target/bin/${CROSS_NAME}-ar /usr/local/osxcross/target/bin/ar \
  && cp /usr/local/osxcross/target/bin/${CROSS_NAME}-ranlib /usr/local/osxcross/target/bin/ranlib

COPY uname /usr/local/osxcross/target/bin/
RUN chmod +x /usr/local/osxcross/target/bin/uname

RUN rustup target add --toolchain stable aarch64-apple-darwin && \
    rustup target add --toolchain nightly aarch64-apple-darwin && \
    mkdir -p /.cargo && \
    echo "[target.aarch64-apple-darwin]" > /.cargo/config && \
    echo "linker = \"aarch64-apple-darwin25.5-clang\"" >> /.cargo/config && \
    echo "ar = \"aarch64-apple-darwin25.5-ar\"" >> /.cargo/config

COPY Toolchain.cmake ${CROSS_PREFIX}/

ENV MACOSX_DEPLOYMENT_TARGET=13.0

ENV CMAKE_TOOLCHAIN_FILE=${CROSS_PREFIX}/Toolchain.cmake

ENV OSXCROSS_PKG_CONFIG_USE_NATIVE_VARIABLES=1

ENV OSXCROSS_MP_INC=1 

RUN cd /opt \
  && wget https://github.com/mmicko/macos-resources/releases/download/v4/Qt6.10.2-arm64.tar.gz \
  && tar xfz Qt6.10.2-arm64.tar.gz \
  && rm Qt6.10.2-arm64.tar.gz \
  && rm -rf /opt/Qt6.10.2/bin \
  && rm -rf /opt/Qt6.10.2/libexec \
  && ln -s /usr/lib/qt6/bin /opt/Qt6.10.2/bin \
  && ln -s /usr/lib/qt6/libexec /opt/Qt6.10.2/libexec \
  && cd /tmp \
  && wget https://github.com/mmicko/macos-resources/releases/download/v4/macports-darwin-arm64.tar.gz \
  && tar xf macports-darwin-arm64.tar.gz  --warning=no-unknown-keyword \
  && cd / \
  && echo "Install atk-2.38.0_2.darwin_25.arm64" \
  && cp -rf /tmp/atk/atk-2.38.0_2.darwin_25.arm64/* / \
  && echo "Install boost176/boost176-1.76.0_15+no_single.darwin_25.arm64" \
  && cp -rf /tmp/boost176/boost176-1.76.0_15+no_single.darwin_25.arm64/* / \
  && echo "Install brotli/brotli-1.2.0_0.darwin_25.arm64" \
  && cp -rf /tmp/brotli/brotli-1.2.0_0.darwin_25.arm64/* / \
  && echo "Install bzip2/bzip2-1.0.8_0.darwin_25.arm64" \
  && cp -rf /tmp/bzip2/bzip2-1.0.8_0.darwin_25.arm64/* / \
  && echo "Install cairo/cairo-1.18.4_2+quartz.darwin_25.arm64" \
  && cp -rf /tmp/cairo/cairo-1.18.4_2+quartz.darwin_25.arm64/* / \
  && echo "Install curl/curl-8.21.0_0+brotli+idn+psl+ssl+zstd.darwin_25.arm64" \
  && cp -rf /tmp/curl/curl-8.21.0_0+brotli+idn+psl+ssl+zstd.darwin_25.arm64/* / \
  && echo "Install eigen3/eigen3-3.4.1_0.any_any.noarch" \
  && cp -rf /tmp/eigen3/eigen3-3.4.1_0.any_any.noarch/* / \
  && echo "Install expat/expat-2.8.2_0.darwin_25.arm64" \
  && cp -rf /tmp/expat/expat-2.8.2_0.darwin_25.arm64/* / \
  && echo "Install fontconfig/fontconfig-2.18.1_0.darwin_25.arm64" \
  && cp -rf /tmp/fontconfig/fontconfig-2.18.1_0.darwin_25.arm64/* / \
  && echo "Install freetype/freetype-2.14.3_0.darwin_25.arm64" \
  && cp -rf /tmp/freetype/freetype-2.14.3_0.darwin_25.arm64/* / \
  && echo "Install fribidi/fribidi-1.0.16_0.darwin_25.arm64" \
  && cp -rf /tmp/fribidi/fribidi-1.0.16_0.darwin_25.arm64/* / \
  && echo "Install gdbm/gdbm-1.26_0.darwin_25.arm64" \
  && cp -rf /tmp/gdbm/gdbm-1.26_0.darwin_25.arm64/* / \
  && echo "Install gdk-pixbuf2/gdk-pixbuf2-2.44.6_0.darwin_25.arm64" \
  && cp -rf /tmp/gdk-pixbuf2/gdk-pixbuf2-2.44.6_0.darwin_25.arm64/* / \
  && echo "Install gettext/gettext-1.0_0.darwin_25.arm64" \
  && cp -rf /tmp/gettext/gettext-1.0_0.darwin_25.arm64/* / \
  && echo "Install gettext-runtime/gettext-runtime-1.0_0.darwin_25.arm64" \
  && cp -rf /tmp/gettext-runtime/gettext-runtime-1.0_0.darwin_25.arm64/* / \
  && echo "Install glib2/glib2-2.88.2_0+quartz.darwin_25.arm64" \
  && cp -rf /tmp/glib2/glib2-2.88.2_0+quartz.darwin_25.arm64/* / \
  && echo "Install gmp/gmp-6.3.0_0.darwin_25.arm64" \
  && cp -rf /tmp/gmp/gmp-6.3.0_0.darwin_25.arm64/* / \
  && echo "Install gobject-introspection/gobject-introspection-1.86.0_1.darwin_25.arm64" \
  && cp -rf /tmp/gobject-introspection/gobject-introspection-1.86.0_1.darwin_25.arm64/* / \
  && echo "Install graphite2/graphite2-1.3.14_0.darwin_25.arm64" \
  && cp -rf /tmp/graphite2/graphite2-1.3.14_0.darwin_25.arm64/* / \
  && echo "Install gtk3/gtk3-3.24.52_1+quartz.darwin_25.arm64" \
  && cp -rf /tmp/gtk3/gtk3-3.24.52_1+quartz.darwin_25.arm64/* / \
  && echo "Install gtk-osx-application-common-gtk3/gtk-osx-application-common-gtk3-3.0.2_1.darwin_25.arm64" \
  && cp -rf /tmp/gtk-osx-application-common-gtk3/gtk-osx-application-common-gtk3-3.0.2_1.darwin_25.arm64/* / \
  && echo "Install gtk-osx-application-gtk3/gtk-osx-application-gtk3-3.0.2_1.darwin_25.arm64" \
  && cp -rf /tmp/gtk-osx-application-gtk3/gtk-osx-application-gtk3-3.0.2_1.darwin_25.arm64/* / \
  && echo "Install harfbuzz/harfbuzz-14.2.1_0.darwin_25.arm64" \
  && cp -rf /tmp/harfbuzz/harfbuzz-14.2.1_0.darwin_25.arm64/* / \
  && echo "Install hidapi/hidapi-0.15.0_0.darwin_25.arm64" \
  && cp -rf /tmp/hidapi/hidapi-0.15.0_0.darwin_25.arm64/* / \
  && echo "Install icu/icu-78.3_1.darwin_25.arm64" \
  && cp -rf /tmp/icu/icu-78.3_1.darwin_25.arm64/* / \
  && echo "Install lerc/lerc-4.1.0_0.darwin_25.arm64" \
  && cp -rf /tmp/lerc/lerc-4.1.0_0.darwin_25.arm64/* / \
  && echo "Install libdeflate/libdeflate-1.25_0.darwin_25.arm64" \
  && cp -rf /tmp/libdeflate/libdeflate-1.25_0.darwin_25.arm64/* / \
  && echo "Install libedit/libedit-20260512-3.1_0.darwin_25.arm64" \
  && cp -rf /tmp/libedit/libedit-20260512-3.1_0.darwin_25.arm64/* / \
  && echo "Install libepoxy/libepoxy-1.5.10_4+quartz.darwin_25.arm64" \
  && cp -rf /tmp/libepoxy/libepoxy-1.5.10_4+quartz.darwin_25.arm64/* / \
  && echo "Install libffi/libffi-3.4.8_0.darwin_25.arm64" \
  && cp -rf /tmp/libffi/libffi-3.4.8_0.darwin_25.arm64/* / \
  && echo "Install libftdi1/libftdi1-1.5_2.darwin_25.arm64" \
  && cp -rf /tmp/libftdi1/libftdi1-1.5_2.darwin_25.arm64/* / \
  && echo "Install libiconv/libiconv-1.18_0.darwin_25.arm64" \
  && cp -rf /tmp/libiconv/libiconv-1.18_0.darwin_25.arm64/* / \
  && echo "Install libidn2/libidn2-2.3.8_0.darwin_25.arm64" \
  && cp -rf /tmp/libidn2/libidn2-2.3.8_0.darwin_25.arm64/* / \
  && echo "Install libjpeg-turbo/libjpeg-turbo-3.2.0_0.darwin_25.arm64" \
  && cp -rf /tmp/libjpeg-turbo/libjpeg-turbo-3.2.0_0.darwin_25.arm64/* / \
  && echo "Install libpixman/libpixman-0.46.0_0.darwin_25.arm64" \
  && cp -rf /tmp/libpixman/libpixman-0.46.0_0.darwin_25.arm64/* / \
  && echo "Install libpng/libpng-1.6.58_0.darwin_25.arm64" \
  && cp -rf /tmp/libpng/libpng-1.6.58_0.darwin_25.arm64/* / \
  && echo "Install libpsl/libpsl-0.22.0-20260624_0.darwin_25.arm64" \
  && cp -rf /tmp/libpsl/libpsl-0.22.0-20260624_0.darwin_25.arm64/* / \
  && echo "Install libtool/libtool-2.5.4_0.darwin_25.arm64" \
  && cp -rf /tmp/libtool/libtool-2.5.4_0.darwin_25.arm64/* / \
  && echo "Install libunistring/libunistring-1.4.2_0.darwin_25.arm64" \
  && cp -rf /tmp/libunistring/libunistring-1.4.2_0.darwin_25.arm64/* / \
  && echo "Install libusb/libusb-1.0.30_0.darwin_25.arm64" \
  && cp -rf /tmp/libusb/libusb-1.0.30_0.darwin_25.arm64/* / \
  && echo "Install mpfr/mpfr-4.2.2_0.darwin_25.arm64" \
  && cp -rf /tmp/mpfr/mpfr-4.2.2_0.darwin_25.arm64/* / \
  && echo "Install ncurses/ncurses-6.6_0.darwin_25.arm64" \
  && cp -rf /tmp/ncurses/ncurses-6.6_0.darwin_25.arm64/* / \
  && echo "Install openssl/openssl-3_31.darwin_25.arm64" \
  && cp -rf /tmp/openssl/openssl-3_31.darwin_25.arm64/* / \
  && echo "Install openssl3/openssl3-3.6.3_0.darwin_25.arm64" \
  && cp -rf /tmp/openssl3/openssl3-3.6.3_0.darwin_25.arm64/* / \
  && echo "Install pango/pango-1.57.1_0+quartz.darwin_25.arm64" \
  && cp -rf /tmp/pango/pango-1.57.1_0+quartz.darwin_25.arm64/* / \
  && echo "Install pcre2/pcre2-10.47_0.darwin_25.arm64" \
  && cp -rf /tmp/pcre2/pcre2-10.47_0.darwin_25.arm64/* / \
  && echo "Install readline/readline-8.3.003_0.darwin_25.arm64" \
  && cp -rf /tmp/readline/readline-8.3.003_0.darwin_25.arm64/* / \
  && echo "Install realpath/realpath-1.0.2_0.darwin_25.arm64" \
  && cp -rf /tmp/realpath/realpath-1.0.2_0.darwin_25.arm64/* / \
  && echo "Install sqlite3/sqlite3-3.53.3_0.darwin_25.arm64" \
  && cp -rf /tmp/sqlite3/sqlite3-3.53.3_0.darwin_25.arm64/* / \
  && echo "Install tcl8/tcl8-8.6.18_0+corefoundation+threads.darwin_25.arm64" \
  && cp -rf /tmp/tcl8/tcl8-8.6.18_0+corefoundation+threads.darwin_25.arm64/* / \
  && echo "Install tiff/tiff-4.7.2_0.darwin_25.arm64" \
  && cp -rf /tmp/tiff/tiff-4.7.2_0.darwin_25.arm64/* / \
  && echo "Install tk/tk-8.6.18_0+quartz.any_any.arm64" \
  && cp -rf /tmp/tk/tk-8.6.18_0+quartz.any_any.arm64/* / \
  && echo "Install tk8-quartz/tk8-quartz-8.6.18_0.darwin_25.arm64" \
  && cp -rf /tmp/tk8-quartz/tk8-quartz-8.6.18_0.darwin_25.arm64/* / \
  && echo "Install xz/xz-5.8.3_0.darwin_25.arm64" \
  && cp -rf /tmp/xz/xz-5.8.3_0.darwin_25.arm64/* / \
  && echo "Install zlib/zlib-1.3.2_0.darwin_25.arm64" \
  && cp -rf /tmp/zlib/zlib-1.3.2_0.darwin_25.arm64/* / \
  && echo "Install zstd/zstd-1.5.7_0.darwin_25.arm64" \
  && cp -rf /tmp/zstd/zstd-1.5.7_0.darwin_25.arm64/* / \
  && echo "Cleanup" \
  && cp -r /opt/local/libexec/boost/1.76/include/* /opt/local/include/. \
  && cp -r /opt/local/libexec/boost/1.76/lib/* /opt/local/lib/. \
  && cp /usr/include/FlexLexer.h /opt/local/include/. \
  && cp -r /opt/local/share/pkgconfig/* /opt/local/lib/pkgconfig/. \  
  && cp -r /opt/local/share/cmake /tmp \
  && cp -r /opt/local/share/eigen3 /tmp \
  && cp -r /opt/local/share/gir-1.0 /tmp \
  && cp -r /opt/local/share/glib-2.0 /tmp \
  && cp -r /opt/local/share/terminfo /tmp \
  && rm -rf /opt/local/etc \
  && rm -rf /opt/local/sbin \
  && rm -rf /opt/local/share \
  && mkdir -p /opt/local/share \
  && mv /tmp/cmake /opt/local/share \
  && mv /tmp/eigen3 /opt/local/share \
  && mv /tmp/gir-1.0 /opt/local/share \
  && mv /tmp/glib-2.0 /opt/local/share \
  && mv /tmp/terminfo /opt/local/share \
  && rm -rf /tmp/* \
  && mkdir -p /usr/local/osxcross/target/macports/pkgs/opt \
  && ln -s /opt/local /usr/local/osxcross/target/macports/pkgs/opt \
  && cp /opt/local/lib/pkgconfig/gtk-mac-integration-gtk3.pc /opt/local/lib/pkgconfig/gtk-mac-integration.pc

#
# Install just g-ir-compiler, not using apt since it adds lots more
RUN cd /tmp && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/g/gobject-introspection/libgirepository-1.0-1_1.86.0-6build1_amd64.deb && \
    dpkg-deb -xv libgirepository-1.0-1_1.86.0-6build1_amd64.deb / && \
    rm -rf libgirepository-1.0-1_1.86.0-6build1_amd64.deb && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/g/gobject-introspection/gobject-introspection_1.86.0-6build1_amd64.deb && \
    dpkg-deb -xv gobject-introspection_1.86.0-6build1_amd64.deb / && \
    rm -rf gobject-introspection_1.86.0-6build1_amd64.deb && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/g/gobject-introspection/gobject-introspection-bin_1.86.0-6build1_amd64.deb && \
    dpkg-deb -xv gobject-introspection-bin_1.86.0-6build1_amd64.deb / && \
    rm -rf gobject-introspection-bin_1.86.0-6build1_amd64.deb 

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

ENV CMAKE_POLICY_VERSION_MINIMUM=3.5
ENV PIP_BREAK_SYSTEM_PACKAGES=1
