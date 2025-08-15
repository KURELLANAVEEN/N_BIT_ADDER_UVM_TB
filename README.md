# N_BIT_ADDER_UVM_TB

Hi,

This repo is all about UVM Test Bench for verifying `n-bit adder`.

This project is for complete beginners who want to understand the flow of a UVM testbench. In each testbench file, I have added comments for important lines. The main goal is to understand how communication happens between UVM components so that you can verify the actual design.

Note:
  -This design is an N-bit adder, as the name suggests, capable of handling multiple bit-widths through the parameter N. The adder supports only unsigned numbers. Our UVM testbench is       also written to verify the design for different bit-widths by varying this parameter.

  -Before running simulation, you need to update the value of N in the `global_values_pkg` package in `adder_tb_pkg.sv` file to the desired bit-width.

  Example:
  If you want to verify a 4-bit unsigned adder, set N = 4 in the global_values_pkg package. After that, run the `adder_base_test` testcase in tb_top.sv. Similarly, for an 8-bit unsigned      adder, set N = 8 and run the `adder_base_test` testcase.

Below is the link about "nbit adder", you can learn it's working and significance.
  `https://www.tutorialspoint.com/digital-electronics/digital-electronics-n-bit-parallel-adders.htm`

Test Plan:
 `https://docs.google.com/spreadsheets/d/1YLPBp1tqOkAq4grNwCso51ZPu4MF6TwBrHce0I7QKQM/edit?usp=sharing`

EDA Playground with code( Simulator: Synposis VCS):
  `https://edaplayground.com/x/jJY_`

Contributions and feedback are welcome to improve the codebase.

Thanks,
Naveen Kurella.
