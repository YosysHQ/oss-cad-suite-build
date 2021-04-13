cd ${OUTPUT_DIR}${INSTALL_PREFIX}

for bindir in ${BIN_DIRS}; do
    for binfile in $(file -h $bindir/* | grep PE32 | grep executable | cut -f1 -d:); do
        for f in `peldd --all $binfile --wlist uxtheme.dll --wlist userenv.dll --wlist opengl32.dll | grep sys-root | sed -e 's/.*=..//' | sed -e 's/ (0.*)//'`; do
            cp -v "$f" lib/.
        done
    done
done

for scriptdir in ${PY_DIRS}; do
    for script in $(file $scriptdir/* | cut -f1 -d:); do
        if $(head -1 "${script}" | grep -q python); then
            if [[ $script == *-script.py ]]; then
                ${CC} -DGUI=0 -O -s -o ${script/-script.py/.exe} ${PATCHES_DIR}/win-launcher.c
            elif [[ $script == */icebox.py ]]; then
                echo "Ignore icebox.py"
            else
                cp ${script} ${script/.py/}-script.py
                ${CC} -DGUI=0 -O -s -o ${script/.py/}.exe ${PATCHES_DIR}/win-launcher.c
            fi
        fi
    done
done

for scriptdir in ${PY_DIRS}; do
    for script in $(file $scriptdir/* | cut -f1 -d:); do
        if $(head -1 "${script}" | grep -q python); then
            if [[ $script == *-script.py ]]; then
                echo "Ignore $script"
            elif [[ $script == */icebox.py ]]; then
                echo "Ignore icebox.py"
            else
                rm -rf ${script}
            fi
        fi
    done
done
${CC} -DGUI=0 -O -s -o bin/yosys-smtbmc.exe ${PATCHES_DIR}/win-launcher.c
