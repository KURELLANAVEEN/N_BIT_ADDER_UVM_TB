`timescale 1ns/1ps

module tb_n_bit_adder;

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
  adder_if #(.N(N)) adder_vif (.clk(clk), .rst_n(rst_n));

  // DUT instantiation
  n_bit_adder #(.N(N)) DUT (.A(adder_vif.a), 
                            .B(adder_vif.b),
                            .SUM(adder_vif.sum),
                            .CARRY(adder_vif.carry));

  initial begin
    $dumpfile("wave.vcd");
  	$dumpvars(0, tb_n_bit_adder);

    // Connect interface to UVM
    uvm_config_db#(virtual adder_if#(N))::set(null, "*", "vif", adder_vif);

    $display("Starting UVM TestBench....");
    run_test("adder_base_test");
  end
endmodule : tb_n_bit_adder