cd picosat
./configure.sh
make
mkdir -p ${OUTPUT_DIR}/dev
cp picosat.o ${OUTPUT_DIR}/dev/.
cp picosat.h ${OUTPUT_DIR}/dev/.
cp VERSION ${OUTPUT_DIR}/dev/.
