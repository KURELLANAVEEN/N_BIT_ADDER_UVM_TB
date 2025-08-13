//Coordinates with sequences to send adder_transaction objects to the driver.
//The uvm_sequencer base class already implements all the necessary sequencer behavior.
//We usually do not need to add any code or override anything in your custom sequencer class.
//our sequencer subclass mainly exists to specify the transaction type (adder_transaction) via parameterization and enable factory registration.

class adder_sequencer extends uvm_sequencer #(adder_transaction);
  `uvm_component_utils(adder_sequencer)
  function new(string name = "adder_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

endclass