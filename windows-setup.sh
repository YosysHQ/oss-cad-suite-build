echo "Install tools"
pacman -S --noconfirm --noprogressbar \
	autoconf \
	git \
	automake \
	bison \
	flex \
	gperf \
	make \
	patch \
	python3 \
	python3-pip \
	rsync \
	subversion \
	tar \
	unzip \
	wget

echo "Install compilers and libraries"
pacman -S --noconfirm --noprogressbar \
	mingw-w64-x86_64-boost \
	mingw-w64-x86_64-clang \
	mingw-w64-x86_64-cmake \
	mingw-w64-x86_64-curl \
	mingw-w64-x86_64-eigen3 \
	mingw-w64-x86_64-gcc-ada \
	mingw-w64-x86_64-gtk2 \
	mingw-w64-x86_64-libftdi \
	mingw-w64-x86_64-libusb \
	mingw-w64-x86_64-ntldd \
	mingw-w64-x86_64-qt5 \
	mingw-w64-x86_64-readline \
	mingw-w64-x86_64-tcl

cp /usr/include/FlexLexer.h /mingw64/include/.