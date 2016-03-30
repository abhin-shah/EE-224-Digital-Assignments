Please use the following commands to run the codes.

ghdl -a DividePackage.vhd
ghdl -a *.vhd
ghdl -m testbench
./testbench --stop-time=100000000ns --vcd=run.vcd
gtkwave run.vcd