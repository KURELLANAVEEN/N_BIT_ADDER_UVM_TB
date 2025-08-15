// ---------------------------------------1. adder_random_sequence---------------------------------------------------

class adder_random_sequence extends uvm_sequence#(adder_transaction);

  `uvm_object_utils(adder_random_sequence)

  function new(string name = "adder_random_sequence");
    super.new(name);
  endfunction

  virtual task body();
    adder_transaction tr_h;
    //looping construct. It executes the code in the begin ... end block exactly 20 times.
    repeat (10) begin
      tr_h = adder_transaction::type_id::create("tr_h");
      assert (tr_h.randomize()); 
      start_item(tr_h);
      finish_item(tr_h);
    end
  endtask
endclass : adder_random_sequence

// ---------------------------------2. adder_corner_sequence--------------------------------------------------

class adder_corner_sequence extends uvm_sequence#(adder_transaction);
  
  `uvm_object_utils(adder_corner_sequence)

  function new(string name = "adder_corner_sequence");
    super.new(name);
  endfunction

  virtual task body();
    adder_transaction tr_zero, tr_max;

    // Zero input transaction
    tr_zero = adder_transaction::type_id::create("tr_zero");
    tr_zero.a = 0;
    tr_zero.b = 0;
    start_item(tr_zero);
    finish_item(tr_zero);

    // Max input transaction
    tr_max = adder_transaction::type_id::create("tr_max");
    tr_max.a = (1 << N) - 1;   // max value for N bits
    tr_max.b = (1 << N) - 1;   // max value for N bits
    start_item(tr_max);
    finish_item(tr_max);

  endtask
endclass : adder_corner_sequence
