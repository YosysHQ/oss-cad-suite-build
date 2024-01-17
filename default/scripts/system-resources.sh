mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/bin
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins
cp ${PATCHES_DIR}/tabbyadm ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/.

if [ ${ARCH_BASE} == 'linux' ]; then
    # Linux section
    cp ${PATCHES_DIR}/environment ${OUTPUT_DIR}${INSTALL_PREFIX}/.

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts ${OUTPUT_DIR}${INSTALL_PREFIX}/share/fonts
    cp -r /usr/share/fonts/. ${OUTPUT_DIR}${INSTALL_PREFIX}/share/fonts
    cp -r /etc/fonts/.   ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts
    rm ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts/fonts.conf
    cp ${PATCHES_DIR}/fonts.conf.template ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/fonts/.
    cp ${PATCHES_DIR}/cacert.pem ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/.

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    cp -r /usr/share/tcltk/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
    cp -r /usr/share/tcltk/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6

    cp -rv /usr/lib/${CROSS_NAME}/qt5/plugins/* ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins/.
    
    cp -rL /usr/lib/${CROSS_NAME}/libGLX_*.so.0 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/dri
if [ ${ARCH} == 'linux-x64' ]; then
    cp /usr/lib/${CROSS_NAME}/dri/crocus_dri.so ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/dri/.
    cp /usr/lib/${CROSS_NAME}/dri/i965_dri.so ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/dri/.
    pushd ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/dri
    ln -s crocus_dri.so d3d12_dri.so
    ln -s crocus_dri.so i915_dri.so
    ln -s crocus_dri.so iris_dri.so
    ln -s crocus_dri.so kms_swrast_dri.so
    ln -s crocus_dri.so nouveau_dri.so
    ln -s crocus_dri.so r300_dri.so
    ln -s crocus_dri.so r600_dri.so
    ln -s crocus_dri.so radeonsi_dri.so
    ln -s crocus_dri.so swrast_dri.so
    ln -s crocus_dri.so virtio_gpu_dri.so
    ln -s crocus_dri.so vmwgfx_dri.so
    ln -s crocus_dri.so zink_dri.so 
    ln -s i965_dri.so nouveau_vieux_dri.so
    ln -s i965_dri.so r200_dri.so
    ln -s i965_dri.so radeon_dri.so 
    popd
fi
if [ ${ARCH} == 'linux-arm64' ]; then
    cp /usr/lib/${CROSS_NAME}/dri/armada-drm_dri.so ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/dri/.
    cp /usr/lib/${CROSS_NAME}/dri/nouveau_vieux_dri.so ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/dri/.
    pushd ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/dri
    ln -s armada-drm_dri.so d3d12_dri.so
    ln -s armada-drm_dri.so etnaviv_dri.so
    ln -s armada-drm_dri.so exynos_dri.so
    ln -s armada-drm_dri.so hx8357d_dri.so
    ln -s armada-drm_dri.so ili9225_dri.so
    ln -s armada-drm_dri.so ili9341_dri.so
    ln -s armada-drm_dri.so imx-dcss_dri.so
    ln -s armada-drm_dri.so imx-drm_dri.so
    ln -s armada-drm_dri.so imx-lcdif_dri.so
    ln -s armada-drm_dri.so ingenic-drm_dri.so
    ln -s armada-drm_dri.so kgsl_dri.so
    ln -s armada-drm_dri.so kirin_dri.so
    ln -s armada-drm_dri.so kms_swrast_dri.so
    ln -s armada-drm_dri.so komeda_dri.so
    ln -s armada-drm_dri.so lima_dri.so
    ln -s armada-drm_dri.so mali-dp_dri.so
    ln -s armada-drm_dri.so mcde_dri.so
    ln -s armada-drm_dri.so mediatek_dri.so
    ln -s armada-drm_dri.so meson_dri.so
    ln -s armada-drm_dri.so mi0283qt_dri.so
    ln -s armada-drm_dri.so msm_dri.so
    ln -s armada-drm_dri.so mxsfb-drm_dri.so
    ln -s armada-drm_dri.so nouveau_dri.so
    ln -s armada-drm_dri.so panfrost_dri.so
    ln -s armada-drm_dri.so pl111_dri.so
    ln -s armada-drm_dri.so r300_dri.so
    ln -s armada-drm_dri.so r600_dri.so
    ln -s armada-drm_dri.so radeonsi_dri.so
    ln -s armada-drm_dri.so rcar-du_dri.so
    ln -s armada-drm_dri.so repaper_dri.so
    ln -s armada-drm_dri.so rockchip_dri.so
    ln -s armada-drm_dri.so st7586_dri.so
    ln -s armada-drm_dri.so st7735r_dri.so
    ln -s armada-drm_dri.so stm_dri.so
    ln -s armada-drm_dri.so sun4i-drm_dri.so
    ln -s armada-drm_dri.so swrast_dri.so
    ln -s armada-drm_dri.so tegra_dri.so
    ln -s armada-drm_dri.so v3d_dri.so
    ln -s armada-drm_dri.so vc4_dri.so
    ln -s armada-drm_dri.so virtio_gpu_dri.so
    ln -s armada-drm_dri.so vmwgfx_dri.so
    ln -s armada-drm_dri.so zink_dri.so
    ln -s nouveau_vieux_dri.so r200_dri.so
    ln -s nouveau_vieux_dri.so radeon_dri.so
    popd
fi

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec
    cp -v `pkg-config --variable=gdk_pixbuf_binarydir gdk-pixbuf-2.0`/../gdk-pixbuf-query-loaders ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec/.
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gdk-pixbuf-2.0
    cp -r `pkg-config --variable=gdk_pixbuf_binarydir gdk-pixbuf-2.0`/loaders ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gdk-pixbuf-2.0/.

    # GTK3 resources
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/share/glib-2.0
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/share/mime
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/share/icons
    cp -rv /usr/share/glib-2.0/schemas ${OUTPUT_DIR}${INSTALL_PREFIX}/share/glib-2.0/.
    cp -v /usr/share/mime/magic ${OUTPUT_DIR}${INSTALL_PREFIX}/share/mime/.
    cp -rv /usr/share/icons/Adwaita ${OUTPUT_DIR}${INSTALL_PREFIX}/share/icons/.
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/share/icons/Adwaita/256x256
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/share/icons/Adwaita/512x512
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/share/icons/Adwaita/cursors
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/share/icons/Adwaita/icon-theme.cache
fi

if [ ${ARCH_BASE} == 'darwin' ]; then
    cp ${PATCHES_DIR}/environment ${OUTPUT_DIR}${INSTALL_PREFIX}/.
    cp ${PATCHES_DIR}/activate ${OUTPUT_DIR}${INSTALL_PREFIX}/.
    chmod 755 ${OUTPUT_DIR}${INSTALL_PREFIX}/activate

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/etc
    cp ${PATCHES_DIR}/cacert.pem ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/.

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/Frameworks
    cp -r /opt/Qt5.15.3/lib/*.framework ${OUTPUT_DIR}${INSTALL_PREFIX}/Frameworks/.
    cp -rv /opt/Qt5.15.3/plugins/* ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins/.
    find  ${OUTPUT_DIR}${INSTALL_PREFIX}/Frameworks -type d -name Headers -prune -exec rm -rf {} +
    find  ${OUTPUT_DIR}${INSTALL_PREFIX}/Frameworks -type l -name Headers -prune -exec rm -rf {} +

    cp -r /opt/local/lib/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
    cp -r /opt/local/lib/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec
    cp /opt/local/bin/gdk-pixbuf-query-loaders ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec/.
    chmod 755 ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec/gdk-pixbuf-query-loaders
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gdk-pixbuf-2.0
    cp -r -L /opt/local/lib/gdk-pixbuf-2.0/2.10.0/loaders ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gdk-pixbuf-2.0/.
    touch ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gtkrc
    chmod 644 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/gdk-pixbuf-2.0/loaders/*
    dylibbundler -of -b -x ${OUTPUT_DIR}${INSTALL_PREFIX}/libexec/gdk-pixbuf-query-loaders -p @executable_path/../lib -d ${OUTPUT_DIR}${INSTALL_PREFIX}/lib

    # GTK3 resources
    cp /opt/local/lib/libgtk-3.0.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    cp /opt/local/lib/libgdk-3.0.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    dylibbundler -of -b -x ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libgtk-3.0.dylib -p @executable_path/../lib -d ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    install_name_tool -id @executable_path/../lib/libgtk-3.0.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libgtk-3.0.dylib
    dylibbundler -of -b -x ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libgdk-3.0.dylib -p @executable_path/../lib -d ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    install_name_tool -id @executable_path/../lib/libgdk-3.0.dylib ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libgdk-3.0.dylib
    rcodesign sign ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libgtk-3.0.dylib
    rcodesign sign ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/libgdk-3.0.dylib
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/share/glib-2.0
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/share/mime
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/share/icons
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/share/terminfo
    cp -rv /opt/local/share/glib-2.0/schemas ${OUTPUT_DIR}${INSTALL_PREFIX}/share/glib-2.0/.
    cp -v /usr/share/mime/magic ${OUTPUT_DIR}${INSTALL_PREFIX}/share/mime/.
    cp -rv /usr/share/icons/Adwaita ${OUTPUT_DIR}${INSTALL_PREFIX}/share/icons/.
    cp -rv /opt/local/share/terminfo/* ${OUTPUT_DIR}${INSTALL_PREFIX}/share/terminfo/.
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/share/icons/Adwaita/256x256
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/share/icons/Adwaita/512x512
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/share/icons/Adwaita/cursors
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/share/icons/Adwaita/icon-theme.cache
fi
if [ ${ARCH_BASE} == 'windows' ]; then
    ${CC} -DGUI=0 -O -s -o ${OUTPUT_DIR}${INSTALL_PREFIX}/win-launcher.exe ${PATCHES_DIR}/win-launcher.c

    cp ${PATCHES_DIR}/environment.bat ${OUTPUT_DIR}${INSTALL_PREFIX}/.
    cp ${PATCHES_DIR}/start.bat ${OUTPUT_DIR}${INSTALL_PREFIX}/.

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/etc
    cp ${PATCHES_DIR}/cacert.pem ${OUTPUT_DIR}${INSTALL_PREFIX}/etc/.

    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    cp /usr/x86_64-w64-mingw32/sys-root/mingw/bin/gdk-pixbuf-query-loaders.exe ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    cp -r /usr/x86_64-w64-mingw32/sys-root/mingw/lib/tcl8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6
    cp -r /usr/x86_64-w64-mingw32/sys-root/mingw/lib/tk8.6/. ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tcl8.6/tclConfig.sh
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/tk8.6/tkConfig.sh

    cp -rv /usr/x86_64-w64-mingw32/sys-root/mingw/lib/qt5/plugins/* ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/qt5/plugins/.

	mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib
    cp -rf /usr/x86_64-w64-mingw32/sys-root/mingw/lib/gdk-pixbuf-2.0 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.

    # GTK3 resources
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/share/glib-2.0
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/share/icons
    cp -rv /usr/x86_64-w64-mingw32/sys-root/mingw/share/glib-2.0/schemas ${OUTPUT_DIR}${INSTALL_PREFIX}/share/glib-2.0/.
    cp -rv /usr/x86_64-w64-mingw32/sys-root/mingw/share/icons/Adwaita ${OUTPUT_DIR}${INSTALL_PREFIX}/share/icons/.
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/share/icons/Adwaita/256x256
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/share/icons/Adwaita/512x512
    rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/share/icons/Adwaita/cursors
fi
