cd libpoly
if [ ${ARCH_BASE} == 'windows' ]; then
    # Taken from cvc5 scripts
    # Avoid %z and %llu format specifiers
    find . -type f ! -name "*.orig" -exec \
        sed -i.orig "s/%z[diu]/%\\\" PRIu64 \\\"/g" {} +
    find . -type f ! -name "*.orig" -exec \
        sed -i.orig "s/%ll[du]/%\\\" PRIu64 \\\"/g" {} +

    # Make sure the new macros are available
    find . -type f ! -name "*.orig" -exec \
        sed -i.orig "s/#include <stdio.h>/#include <stdio.h>\\n#include <inttypes.h>/" {} +
    find . -type f ! -name "*.orig" -exec \
        sed -i.orig "s/#include <cstdio>/#include <cstdio>\\n#include <inttypes.h>/" {} +
fi
sed -i  "s,add_subdirectory(test/polyxx),add_subdirectory(test/polyxx EXCLUDE_FROM_ALL),g" CMakeLists.txt
if [ ${ARCH_BASE} == 'darwin' ]; then 
    sed -i "s,-Wall -Werror -Wextra,-Wall -Wextra,g" src/CMakeLists.txt 
fi
cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DLIBPOLY_BUILD_PYTHON_API=OFF \
      -DLIBPOLY_BUILD_STATIC=ON \
      -DLIBPOLY_BUILD_STATIC_PIC=ON
make DESTDIR=${OUTPUT_DIR} install