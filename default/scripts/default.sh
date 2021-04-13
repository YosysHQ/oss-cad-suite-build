cd ${OUTPUT_DIR}${INSTALL_PREFIX}
rm -rf ${OUTPUT_DIR}/dev

if [ ${ARCH_BASE} == 'linux' ]; then
# Linux section
mkdir -p bin
mkdir -p license
mkdir -p examples
for package in $(file packages/* | grep directory | cut -f1 -d:); do
    if [ -d $package/bin ]; then
        for binfile in $(file $package/bin/* | cut -f1 -d:); do
            ln -sf ../$binfile bin/$(basename $binfile)
            chmod +x bin/$(basename $binfile)
        done
    fi
    if [ -d $package/license ]; then
        for lfile in $(file $package/license/* | cut -f1 -d:); do
            ln -sf ../$lfile license/$(basename $lfile)
        done
    fi
    if [ -d $package/examples ]; then
        for lfile in $(file $package/examples/* | cut -f1 -d:); do
            ln -sf ../$lfile examples/$(basename $lfile)
        done
    fi
    if [ $package != 'packages/python3' ]; then
        if [ -d $package/lib/python3.8/site-packages ]; then
            for lfile in $(file $package/lib/python3.8/site-packages/*.pth | cut -f1 -d:); do
                cp $lfile packages/python3/lib/python3.8/site-packages/.
                sed -i 's,./,../../../../../'$package'/lib/python3.8/site-packages/,g' packages/python3/lib/python3.8/site-packages/$(basename $lfile)
            done
        fi
    fi
done
# end of Linux section
elif [ ${ARCH_BASE} == 'darwin' ]; then
# Darwin/macOS section
mkdir -p bin
mkdir -p license
mkdir -p examples
for package in $(file packages/* | grep directory | cut -f1 -d:); do
    if [ -d $package/bin ]; then
        for binfile in $(file $package/bin/* | cut -f1 -d:); do
            ln -sf ../$binfile bin/$(basename $binfile)
            chmod +x bin/$(basename $binfile)
        done
    fi
    if [ -d $package/license ]; then
        for lfile in $(file $package/license/* | cut -f1 -d:); do
            ln -sf ../$lfile license/$(basename $lfile)
        done
    fi
    if [ -d $package/examples ]; then
        for lfile in $(file $package/examples/* | cut -f1 -d:); do
            ln -sf ../$lfile examples/$(basename $lfile)
        done
    fi
    if [ $package != 'packages/python3' ]; then
        if [ -d $package/lib/python3.8/site-packages ]; then
            for lfile in $(file $package/lib/python3.8/site-packages/*.pth | cut -f1 -d:); do
                cp $lfile packages/python3/lib/python3.8/site-packages/.
                sed -i 's,./,../../../../../'$package'/lib/python3.8/site-packages/,g' packages/python3/lib/python3.8/site-packages/$(basename $lfile)
            done
        fi
    fi
done

# end of Darwin/macOS section
elif [ ${ARCH_BASE} == 'windows' ]; then
# Windows section
    echo "TODO"
# end of Windows section
fi

chmod -R u=rwX,go=rX *
