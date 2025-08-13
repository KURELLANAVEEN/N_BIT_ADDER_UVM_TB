/* This is the data model of what will be sent to the DUT.
Defines fields like A, B, expected outputs, etc.
Can have constraints for randomization */

`ifndef ADDER_TXN
`define ADDER_TXN

import adder_tb_pkg::*;

class adder_transaction extends uvm_sequence_item;
  // DUT input & output stimulus fields
  rand bit [N-1:0] a;
  rand bit [N-1:0] b;
  bit [N-1:0] sum;
  bit carry;

  bit [N:0] expected_full;
  bit [N-1:0] expected_sum;
  bit expected_carry;

  // Constraints
  constraint input_valid_range{
    A inside {[0 : (2**N)-1]};
    B inside {[0 : (2**N)-1]};
  }

  `uvm_object_utils_begin(adder_transaction)
    `uvm_field_int(a, UVM_ALL_ON)
    `uvm_field_int(b, UVM_ALL_ON)
    `uvm_field_int(sum, UVM_ALL_ON)
    `uvm_field_int(carry, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "adder_transaction");
    super.new(name);
  endfunction

  // updates the expected fields (sum & carry) inside the transaction object.
  function void calc_expected();
    expected_full = a + b;
    expected_sum  = expected_full[N-1:0];
    expected_cout = expected_full[N];

    `uvm_info("CALC_EXPECTED", $sformatf("Expected Total = %0d", expected_full), UVM_MEDIUM)
  endfunction

endclass

`endif