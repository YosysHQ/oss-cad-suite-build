cd surelog/third_party/UHDM/third_party/capnproto
cmake -DCMAKE_BUILD_TYPE=Release
make DESTDIR=${OUTPUT_DIR} -j${NPROC} install