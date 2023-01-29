#! /bin/bash
apt install gnat
apt install clang
apt install llvm
echo "Installing dependencies"
apt-get install libedit clang lldb lld pkg-config zlib1g-dev gnat

echo "Downloading ghdl sources"
wget https://github.com/ghdl/ghdl/archive/master.tar.gz
tar -xvf master.tar.gz
rm master.tar.gz
cd ghdl-master && mkdir -p build 
cd build && ../configure --with-llvm-config=/usr/bin/llvm-config --prefix=/opt/ghdl
make 
make install 

echo "export ghdl=/opt/ghdl/bin/ghdl" >> ~/.bashrc
source ~/.bashrc

# https://ghdl.github.io/ghdl/development/building/LLVM.html