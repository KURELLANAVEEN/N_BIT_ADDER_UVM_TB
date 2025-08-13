`timescale 1ns/1ps

import uvm_pkg::*; 
`include "uvm_macros.svh"

`include "adder_interface.sv"
`include "adder_tb_pkg.sv"

module tb_top;
  parameter int N = 4;
  n_bit_adder #(.N(N)) DUT (.A(a), .B(b), .SUM(sum), .CARRY(carry));
endmodule