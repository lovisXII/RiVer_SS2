# RISC-V-project

# Introduction :

This project comes with everything developped here :\
https://github.com/lovisXII/RiVer_SoC

We moved the super-scalar implementation here to clean a bit the other repository.

This project started as a project of our 1st year Master and aimed to modernise the architecture studied at Sorbonne University.\
We were offered to continue this project during a 3 month Internship from June 2022 to August 2022.\
This project is the result of about 8 months of works.\
It was realised by :

**Timothée Le Berre**,\
**Louis Geoffroy Pitailler**,\
**Kevin Lastra**,\
**Samy Attal**

 On this git you will find :
- A RISCV 2 ways super-scalar processor in 
SystemC

All of our core are fully operationnal and have been tested using riscof framework and custom tests that you can find in the **SOFT/TESTS/**

Our Kernel architecture supports :
* direct and vectorize mode for mtvec
* it stores the adresse of an instruction responsable of an exception inside mepc
* it stores the value responsable of an exception inside mtval (for instance bad load adress value, missaligned instruction value...etc )

# I. How to compile ?
## A. What's needed 

To compile the project you will need **Systemc version 2.3.3**, g++ and a riscv compiler.
You will find shell script in **Shell_script/** to help you to setup your envirroment. If you trust us enough you can skip this part and go read helper script. Otherwise follow these istruction

### SystemC
```bash
sudo apt install build-essential make wget git gcc g++ automake
wget http://www.accellera.org/images/downloads/standards/systemc/systemc-2.3.3.gz
tar -xzf systemc-2.3.3.gz
mkdir -p systemc-2.3.3/objdir
cd systemc-2.3.3/objdir
../configure --prefix=/usr/local/systemc-2.3.3/
make -j
sudo make install
```
If you use another path for SystemC, you will need to set the SYSTEMC env variable before compilation.

### Riscv32 cross-compiler
*pre-compiled binaries on Ubuntu*
```bash
wget https://github.com/stnolting/riscv-gcc-prebuilt/releases/download/rv32i-2.0.0/riscv32-unknown-elf.gcc-10.2.0.rv32i.ilp32.newlib.tar.gz
sudo mkdir -p /opt/riscv
sudo tar -xzf riscv32-unknown-elf.gcc-10.2.0.rv32i.ilp32.newlib.tar.gz -C /opt/riscv/
rm -f riscv32-unknown-elf.gcc-10.2.0.rv32i.ilp32.newlib.tar.gz
```
Then add it to your PATH by adding the following line to `~/.bashrc` : 
```bash
export PATH=$PATH:/opt/riscv/bin 
```
*re-compiled (safer and works for most systems)*

Follow the instructions here https://github.com/riscv-collab/riscv-gnu-toolchain to build a 32-bit riscv toolchain for freestanding code. 

### Helper script

If you trust us enough to run our script in sudo, then we provide helper scripts (we provide no guarantee the installation will be clean, but it should work).

Several case can occur :
- if you only want to compile one of our SystemC core and you want to play with it, you will need to run :
```
./install_systemc.sh
./install_riscv.sh
```
- if you want to use riscof framework, you will need to run :
```
./install_systemc.sh
./install_riscv.sh
./install_riscof.sh
```
**Please note that if you are running on ubuntu 22.04 you can have issue while installing riscof because of python version. Indeed you need python3.6 overwhise it will not works.**
To avoid this problem, we wrote **install_python_ub_22_04.sh**, so please run it then run riscof.

### Building the project

Once everything is installed you will have to go into ``CORE_SS2/``.\
Once you are in the right directory, you juste have to do a ```make```. It will generate the executable core_tb.\
This executable takes as argument an assembly file or a c one. Once you pass it as an argument, the programm will execute it using our descritption of a RISCV core.\
You will find some test programms in ``/SOFT/TESTS/``.

For example you can run ``core_tb ../../SOFT/TESTS/I/pgcd.c``.

We also write a shell script ``run_all_tests.sh`` that take all the file inside tests/ and execute tehem and print a message saying if the execution was a success or not.

## B. Directory map :

This project is design as follow :\
``RiVer_SoC``\
├── ``BENCHMARK_RESULT`` : result of the performance comparaison between the scalar and super-scalar implementation\
├── ``Documentation`` : some usefull documentation like riscv spec, our project report...etc\
├── ``riscof`` : framework riscof used to validate our model. It contains a lot of assembly tests\
├── ``Shell_script`` : helper script for setup your environment\
├── ``SIM``\
│   ├── ``ELFIO`` : c++ parsor library that we used to parse an elf file in our SystemC implementation\
│   └── ``CORE_SS2`` : source code of the RV32I super-scalar implementation\
├── ``SOFT`` : contains all our software code such as reset and exception handler code
    └── ``TESTS`` : some .c and .s file that we wrote to validate our model\

# III. Micro architecture

If you want details about the Internal architecture of our implemntation please go inside ``Documentation/Reports/Report_*.pdf``.
There is 2 identical reports, one in English and one in French. 

# IV. Writing conventions

If you wish to make changes to our implementation, please feel free to do so. But if you do, please respect the following conventions. For each signal in the HDL there are writing conventions:
* Internal signals must be in **lower case**.
* External (I/O) signals must be in **upper case**.
* The name of a signal should be written like this:
    ```
    quick_description_[X][Y]
    ```
    Where:
    * \[ X \] is either :
        * S: asynchronous signal (does not come from a sequential element) 
        * R: synchronous signal, it comes from a sequential element such as flip-flop, registers, fifos...etc...
    * [ Y ] is the stage from which the signal comes:
        * I: ifetch
        * D: decode
        * E: exe
        * M: memory
        * W: write back
        * R: register file
        * X: interrupt signal from outside the kernel.

For example ``MEM_RES_RM`` is the result that comes out of the mem2wbk fifo (M means it comes out of the mem stage and R means it is a synchronization signal).

