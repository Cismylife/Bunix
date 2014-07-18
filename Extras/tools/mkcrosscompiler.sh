#!/bin/bash
# I can't do the manual thing
#

if [ `whoami` != "root" ]; then
	echo "Error: Need to run as root."
	exit
fi

GCCURLPH="http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-4.9.0/gcc-4.9.0.tar.bz2"
GCCURL="http://ftp.gnu.org/gnu/gcc/gcc-4.9.0/gcc-4.9.0.tar.bz2"
BINUTILSURL="http://ftp.gnu.org/gnu/binutils/binutils-2.22.tar.gz"

# By default this will install the cross compiler
# and binutils to /usr/local/cross
#
PREFIX="/usr/local/cross"
TARGET="i586-elf"

# Downloading some stuff for the cross compiler
cd /usr/src
mkdir build-binutils build-gcc

echo "Downloading gcc 4.9.0... :)"
wget $GCCURLPH
echo "Done!  Downloading GCC 4.9.0"
sleep 3s
echo "Downloading Binutils 2.22"
wget $BINUTILSURL

echo "Extracting the DNA from the seeds."
tar xvf `basename $BINUTILSURL`
tar xvjf `basename $GCCURL`

########################################################
# Start the binutils install
########################################################

cd /usr/src/build-binutils
/usr/src/`basename $BINUTILSURL .tar.gz`/configure --target=${TARGET} --prefix=${PREFIX} --disable-nls
make all
make install
echo "Done installing binutils."

#######################################################
# Start the gcc install
#######################################################

cd /usr/src/build-gcc/
export PATH=$PATH:$PREFIX/bin
/usr/src/`basename $GCCURL .tar.bz2`/configure --target=${TARGET} --prefix=${PREFIX} --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make install-gcc
echo "Done installing gcc."


echo "Your environment should now have a working i586-elf cross compiler tool chain!"
echo 'But first, you need to do this:'
echo '	export PATH=$PATH:/usr/local/cross/bin'
echo " "
echo "Also make sure you have a working nasm assembler."

