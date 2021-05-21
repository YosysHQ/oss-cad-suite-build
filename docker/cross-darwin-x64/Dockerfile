FROM yosyshq/cross-linux-x64:1.1 AS builder

RUN cd /tmp \
    && git clone https://github.com/auriamg/macdylibbundler \
    && cd macdylibbundler \
    && sed -i "s,CXXFLAGS=-O2 -std=c++11,CXXFLAGS=-O2 -std=c++11 -static-libstdc++ -static-libgcc,g" Makefile \
    && make 

FROM yosyshq/cross-base:1.1

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

ENV OSXCROSS_MP_INC=1 

ENV PKG_CONFIG_PATH /opt/local/lib/pkgconfig

RUN cd /opt \
  && wget https://github.com/mmicko/macos-resources/releases/download/v1/Qt5.12.8.tar.gz \   
  && tar xfz Qt5.12.8.tar.gz \
  && rm Qt5.12.8.tar.gz \
  && rm -rf /opt/Qt5.12.8/bin \
  && ln -s /usr/lib/qt5/bin /opt/Qt5.12.8/bin \
  && cd /tmp \
  && wget https://github.com/mmicko/macos-resources/releases/download/v2/macports-darwin-x64.tar \
  && tar xf macports-darwin-x64.tar \
  && cd / \
  && echo "Unpack atk-2.36.0_2.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/atk/atk-2.36.0_2.darwin_18.x86_64.tbz2 \
  && echo "Unpack boost-1.71.0_3+no_single.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/boost/boost-1.71.0_3+no_single.darwin_18.x86_64.tbz2 \
  && echo "Unpack brotli-1.0.9_2.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/brotli/brotli-1.0.9_2.darwin_18.x86_64.tbz2 \
  && echo "Unpack bzip2-1.0.8_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/bzip2/bzip2-1.0.8_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack cairo-1.16.0_2+quartz.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/cairo/cairo-1.16.0_2+quartz.darwin_18.x86_64.tbz2 \
  && echo "Unpack curl-7.76.1_0+ssl.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/curl/curl-7.76.1_0+ssl.darwin_18.x86_64.tbz2 \
  && echo "Unpack eigen3-3.3.9_0.darwin_18.noarch.tbz2" \
  && tar xfj /tmp/eigen3/eigen3-3.3.9_0.darwin_18.noarch.tbz2 \
  && echo "Unpack expat-2.3.0_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/expat/expat-2.3.0_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack fontconfig-2.13.1_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/fontconfig/fontconfig-2.13.1_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack freetype-2.10.4_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/freetype/freetype-2.10.4_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack fribidi-1.0.10_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/fribidi/fribidi-1.0.10_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack gdbm-1.19_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/gdbm/gdbm-1.19_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack gdk-pixbuf2-2.42.2_2.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/gdk-pixbuf2/gdk-pixbuf2-2.42.2_2.darwin_18.x86_64.tbz2 \
  && echo "Unpack gettext-0.19.8.1_2.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/gettext/gettext-0.19.8.1_2.darwin_18.x86_64.tbz2 \
  && echo "Unpack glib2-2.58.3_1+quartz.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/glib2/glib2-2.58.3_1+quartz.darwin_18.x86_64.tbz2 \
  && echo "Unpack gmp-6.2.1_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/gmp/gmp-6.2.1_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack gobject-introspection-1.60.2_6.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/gobject-introspection/gobject-introspection-1.60.2_6.darwin_18.x86_64.tbz2 \
  && echo "Unpack graphite2-1.3.13_1.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/graphite2/graphite2-1.3.13_1.darwin_18.x86_64.tbz2 \
  && echo "Unpack graphviz-2.40.1_4+pangocairo.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/graphviz/graphviz-2.40.1_4+pangocairo.darwin_18.x86_64.tbz2 \
  && echo "Unpack gtk3-3.24.23_0+quartz.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/gtk3/gtk3-3.24.23_0+quartz.darwin_18.x86_64.tbz2 \
  && echo "Unpack gtk-osx-application-common-gtk3-2.0.8_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/gtk-osx-application-common-gtk3/gtk-osx-application-common-gtk3-2.0.8_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack gtk-osx-application-gtk3-2.0.8_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/gtk-osx-application-gtk3/gtk-osx-application-gtk3-2.0.8_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack harfbuzz-2.8.0_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/harfbuzz/harfbuzz-2.8.0_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack hidapi-0.9.0_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/hidapi/hidapi-0.9.0_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack icu-67.1_4.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/icu/icu-67.1_4.darwin_18.x86_64.tbz2 \
  && echo "Unpack libepoxy-1.5.4_1+python38.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/libepoxy/libepoxy-1.5.4_1+python38.darwin_18.x86_64.tbz2 \
  && echo "Unpack libffi-3.3_1.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/libffi/libffi-3.3_1.darwin_18.x86_64.tbz2 \
  && echo "Unpack libftdi1-1.5_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/libftdi1/libftdi1-1.5_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack libiconv-1.16_1.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/libiconv/libiconv-1.16_1.darwin_18.x86_64.tbz2 \
  && echo "Unpack libjpeg-turbo-2.0.6_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/libjpeg-turbo/libjpeg-turbo-2.0.6_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack libpixman-0.38.4_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/libpixman/libpixman-0.38.4_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack libpng-1.6.37_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/libpng/libpng-1.6.37_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack libtool-2.4.6_11.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/libtool/libtool-2.4.6_11.darwin_18.x86_64.tbz2 \
  && echo "Unpack libusb-1.0.24_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/libusb/libusb-1.0.24_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack mesa-19.0.8_1+osmesa+python27.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/mesa/mesa-19.0.8_1+osmesa+python27.darwin_18.x86_64.tbz2 \
  && echo "Unpack ncurses-6.2_1.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/ncurses/ncurses-6.2_1.darwin_18.x86_64.tbz2 \
  && echo "Unpack openssl-1.1.1k_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/openssl/openssl-1.1.1k_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack ossp-uuid-1.6.2_12+perl5_28.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/ossp-uuid/ossp-uuid-1.6.2_12+perl5_28.darwin_18.x86_64.tbz2 \
  && echo "Unpack pango-1.42.4_3+quartz.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/pango/pango-1.42.4_3+quartz.darwin_18.x86_64.tbz2 \
  && echo "Unpack pcre-8.44_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/pcre/pcre-8.44_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack readline-8.1.000_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/readline/readline-8.1.000_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack realpath-1.0.1_1.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/realpath/realpath-1.0.1_1.darwin_18.x86_64.tbz2 \
  && echo "Unpack sqlite3-3.35.5_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/sqlite3/sqlite3-3.35.5_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack tcl-8.6.11_0+corefoundation+threads.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/tcl/tcl-8.6.11_0+corefoundation+threads.darwin_18.x86_64.tbz2 \
  && echo "Unpack tiff-4.3.0_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/tiff/tiff-4.3.0_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack tk-8.6.11_0+quartz.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/tk/tk-8.6.11_0+quartz.darwin_18.x86_64.tbz2 \
  && echo "Unpack xorg-libX11-1.7.0_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/xorg-libX11/xorg-libX11-1.7.0_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack xorg-libxcb-1.14_0+python39.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/xorg-libxcb/xorg-libxcb-1.14_0+python39.darwin_18.x86_64.tbz2 \
  && echo "Unpack xorg-libXdamage-1.1.5_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/xorg-libXdamage/xorg-libXdamage-1.1.5_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack xorg-libXext-1.3.4_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/xorg-libXext/xorg-libXext-1.3.4_0.darwin_18.x86_64.tbz2 \ 
  && echo "Unpack xorg-libXfixes-5.0.3_1.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/xorg-libXfixes/xorg-libXfixes-5.0.3_1.darwin_18.x86_64.tbz2 \
  && echo "Unpack xorg-libpthread-stubs-0.4_0.darwin_18.noarch.tbz2" \
  && tar xfj /tmp/xorg-libpthread-stubs/xorg-libpthread-stubs-0.4_0.darwin_18.noarch.tbz2 \
  && echo "Unpack xorg-libXdmcp-1.1.3_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/xorg-libXdmcp/xorg-libXdmcp-1.1.3_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack xorg-libXau-1.0.9_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/xorg-libXau/xorg-libXau-1.0.9_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack xorg-xcb-proto-1.14.1_0+python39.darwin_18.noarch.tbz2" \
  && tar xfj /tmp/xorg-xcb-proto/xorg-xcb-proto-1.14.1_0+python39.darwin_18.noarch.tbz2 \
  && echo "Unpack xorg-xorgproto-2021.4_0.darwin_18.noarch.tbz2" \
  && tar xfj /tmp/xorg-xorgproto/xorg-xorgproto-2021.4_0.darwin_18.noarch.tbz2 \
  && echo "Unpack xz-5.2.5_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/xz/xz-5.2.5_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack zlib-1.2.11_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/zlib/zlib-1.2.11_0.darwin_18.x86_64.tbz2 \
  && echo "Unpack zstd-1.4.9_0.darwin_18.x86_64.tbz2" \
  && tar xfj /tmp/zstd/zstd-1.4.9_0.darwin_18.x86_64.tbz2 \
  && echo "Cleanup" \
  && cp /usr/include/FlexLexer.h /opt/local/include/. \
  && cp /opt/local/share/pkgconfig/* /opt/local/lib/pkgconfig/. \
  && sed "s|2.0.8|3.0.8|g" -i /opt/local/lib/pkgconfig/gtk-mac-integration-gtk3.pc \
  && cp /opt/local/lib/pkgconfig/gtk-mac-integration-gtk3.pc /opt/local/lib/pkgconfig/gtk-mac-integration.pc \
  && cp -r /opt/local/share/cmake /tmp \
  && cp -r /opt/local/share/eigen3 /tmp \
  && rm -rf /opt/local/etc \
  && rm -rf /opt/local/libexec \
  && rm -rf /opt/local/sbin \
  && rm -rf /opt/local/share \
  && mkdir -p /opt/local/share \
  && rm -rf /tmp/*.tbz2 \
  && mv /tmp/cmake /opt/local/share \
  && mv /tmp/eigen3 /opt/local/share \
  && rm -rf /tmp/* \
  && mkdir -p /usr/local/osxcross/target/macports/pkgs/opt \
  && ln -s /opt/local /usr/local/osxcross/target/macports/pkgs/opt

COPY --from=builder /tmp/macdylibbundler/dylibbundler /usr/local/bin/dylibbundler
RUN chmod +x /usr/local/bin/dylibbundler

RUN cp /usr/local/osxcross/target/bin/x86_64-apple-darwin20.2-otool /usr/local/osxcross/target/bin/otool \
  && cp /usr/local/osxcross/target/bin/x86_64-apple-darwin20.2-install_name_tool /usr/local/osxcross/target/bin/install_name_tool \
  && cp /usr/local/osxcross/target/bin/x86_64-apple-darwin20.2-ar /usr/local/osxcross/target/bin/ar \
  && cp /usr/local/osxcross/target/bin/x86_64-apple-darwin20.2-ranlib /usr/local/osxcross/target/bin/ranlib

COPY uname /usr/local/osxcross/target/bin/
RUN chmod +x /usr/local/osxcross/target/bin/uname
