/*
Takes adder_transaction objects from the sequencer.
It dictates what signals and timing sequences the DUT needs.
Drives the DUT signals via the virtual interface.
Implements the "active" part of the agent.
*/

class adder_driver extends uvm_driver #(adder_transaction);
  `uvm_component_utils(adder_driver)
  
  adder_transaction txn_h;

  virtual adder_if #(N) vif;

  function new(string name = "adder_driver", uvm_component parent = null);
    super.new(name,parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //Get virtual interface from config DB
    if (!uvm_config_db#(virtual adder_if#(N))::get(this,"","vif",vif)) begin
      `uvm_fatal(get_type_name(),"Virtual Interface 'vif' nt set in config DB")
    end
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase); // optional for driver

    // wait for reset release, so that all TB components start in sync
    wait_for_reset_release();

    // forever is a loop, executes indefinitely during simulation
    forever begin
      // wait untill sequencer sends a transaction
      seq_item_port.get_next_item(txn_h);

      //convert high level xtn into pin activity on DUT via VIF.
      drive_item(txn_h);

      // (Optional) updates the expected fields (sum & carry) inside the transaction object.
      // txn_h.calc_expected();

      // Tells to sequencer, that transaction completed send next one.
      seq_item_port.item_done();

      // If reset asserted in middle of driving transaction
      if (!vif.rst_n) begin
        //Ongoing transactions become invalid. The DUT's internal registers get cleared.
        wait_for_reset_release();
      end

    end

  endtask : run_phase
  
  // Wait until rst_n goes high (and a clock edge) so all UVM components align
  task wait_for_reset_release();
    //if reset is already low (asseret state)
    if(!vif.rst_n) begin
      //wait till it becomes high (deassert state)
      @(posedge vif.rst_n);
    end

    // After reset is released, wait for one more +ve edge of clk, so that any uvm components also waiting for reset release are aligned on same clock boundary.
    @(posedge vif.clk);

  endtask : wait_for_reset_release

  //put xtan fields onto dut's input signals. Here we embodies the protocol for interacting with the DUT. For our case it’s a simple adder, so the "protocol" is just putting A and B values onto inputs in sync with the clock.
  task drive_item(adder_transaction txn_h);
    //Wait until the next clocking block event (which is typically something like @(posedge clk) under the hood).
    @(vif.cb);
    //Assigns the transaction’s values for a and b from txn_h into the DUT’s inputs.
    vif.cb.a <= txn_h.a;
    vif.cb.b <= txn_h.b;
    //First clock cycle: input data + valid=1
	vif.cb.valid <= 1'b1;     // <--- Assert valid
 
    //This is giving the DUT one more clocking block event (one clock cycle, typically) to process the 		inputs.
    @(vif.cb);
    //Second clock cycle: data still stable (assuming), but valid deasserted (0), signaling no new data 	this cycle.
    vif.cb.valid <= 1'b0; 

  endtask

endclass : adder_driver