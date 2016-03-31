Please use the following commands to run the codes.

ghdl -a DividerPackage.vhd
ghdl -a *.vhd
ghdl -m testbench_gcd
./testbench_gcd --stop-time=100000000ns --vcd=run.vcd
gtkwave run.vcd
