`timescale 1ns/1ps

import uvm_pkg::*; 
`include "uvm_macros.svh"

`include "adder_interface.sv"
`include "adder_tb_pkg.sv"

module tb_n_bit_adder;

  // Import the parameter N into module scope
  import adder_tb_pkg::*;
  
  logic clk, rst_n;

  // Clock generation
  initial clk = 0;
  always begin
    #5 clk = ~clk;
  end

  // Reset generation
  initial begin
    rst_n = 0;
    repeat (5) @(posedge clk);
    rst_n = 1;
  end

  // Interface instantiation
  adder_if adder_vif #(.N(N)) (.clk(clk), .rst_n(rst_n));

  // DUT instantiation
  n_bit_adder #(.N(N)) DUT (.A(adder_vif.a), 
                            .B(adder_vif.b),
                            .SUM(adder_vif.sum),
                            .CARRY(adder_vif.carry));

  initial begin
    $dumpfile("wave.vcd");
  	$dumpvars(0, tb_n_bit_adder);

    // Connect interface to UVM
    uvm_config_db#(virual adder_vif)::set(null, "*", "vif", adder_vif);

    $display("Starting UVM TestBench....");
    run_test("testcase_1");
  end

endmodule : tb_n_bit_adder