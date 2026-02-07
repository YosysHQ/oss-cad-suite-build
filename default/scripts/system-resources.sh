source ${WORK_DIR}/default/scripts/system-resources-tabby.sh

if [ ${ARCH_BASE} == 'linux' ]; then
    cp ${PATCHES_DIR}/environment.fish ${OUTPUT_DIR}${INSTALL_PREFIX}/.
    cp -rv /usr/lib/${CROSS_NAME}/libdl.so.2 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    cp -rv /usr/lib/${CROSS_NAME}/libpthread.so.0 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    cp -rL /usr/lib/${CROSS_NAME}/libGLX_*.so.0 ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/.
    mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/dri
if [ ${ARCH} == 'linux-x64' ]; then
    cp /usr/lib/${CROSS_NAME}/dri/crocus_dri.so ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/dri/.
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
    ln -s crocus_dri.so i965_dri.so # crocus now handles i965_dri (ubuntu 24.04)
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
fi

if [ ${ARCH_BASE} == 'darwin' ]; then
    cp ${PATCHES_DIR}/environment.fish ${OUTPUT_DIR}${INSTALL_PREFIX}/.
fi
