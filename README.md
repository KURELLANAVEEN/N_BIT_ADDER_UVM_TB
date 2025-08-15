# N_BIT_ADDER_UVM_TB

Hi,

This repo is all about UVM Test Bench for verifying `n-bit adder`.

This project is for complete beginners who want to understand the flow of a UVM testbench. In each testbench file, I have added comments for important lines. The main goal is to understand how communication/flow happens between UVM components so that we can verify the actual design.

Note:
  1.This design is an N-bit adder, as the name suggests, capable of handling multiple bit-widths through the parameter N. The adder supports only unsigned numbers. Our UVM testbench is also written to verify the design for different bit-widths by varying this parameter.

  2.Before running simulation, you need to update the value of N in the `global_values_pkg` package in `adder_tb_pkg.sv` file to the desired bit-width.

  Example:
  If you want to verify a 4-bit unsigned adder, set N = 4 in the global_values_pkg package. After that, run the `adder_base_test` testcase in tb_top.sv. Similarly, for an 8-bit unsigned adder, set N = 8 and run the `adder_base_test` testcase.

Pending tasks (or) To-Do:
  There are other features that still need to be exercised, and I will update the test plan as each feature is verified. Contributions and feedback are welcome to help improve the codebase.

Below is the link about "n-bit adder", you can learn it's working and significance.
  `https://www.tutorialspoint.com/digital-electronics/digital-electronics-n-bit-parallel-adders.htm`

Test Plan:
 `https://docs.google.com/spreadsheets/d/1YLPBp1tqOkAq4grNwCso51ZPu4MF6TwBrHce0I7QKQM/edit?usp=sharing`

EDA Playground with code( Simulator: Synposis VCS):
  `https://edaplayground.com/x/jJY_`

Thanks,
Naveen Kurella.
