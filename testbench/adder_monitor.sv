/*
Monitor — a passive UVM component that observes DUT signals.
This is  where it continuously watches the DUT’s interface and captures signal activity into transaction objects.
The output of the monitor is transactions sent to scoreboards, coverage collectors, etc., via an analysis port.
*/

class adder_monitor extends uvm_monitor;
  `uvm_component_utils(adder_monitor)
  
  bit [N-1:0] a_now;
  bit [N-1:0] b_now;
  bit [N-1:0] sum_now;
  bit carry_now;
  
  adder_transaction tr;

  //uvm_analysis_port is a Transaction-Level Modeling (TLM) 1 port that provides a broadcast communication mechanism from one component to one or more other components.
  //The port is a write-only broadcast port, meaning the component that owns the port calls write() to send transactions downstream, but it does not expect any response.
  //The type parameter #(adder_transaction) specifies the transaction type that will be sent through this port.
  //The monitor observes signals on the DUT interface and converts these into transaction objects (adder_txn).
  //These transactions need to be sent to other verification components such as scoreboards, coverage collectors, or other analysis blocks.
  //The analysis port acts as the channel through which these transactions flow without requiring the monitor to know who is receiving them.
  //Your monitor creates and populates adder_txn objects reflecting observed DUT signals.
  //It then calls ap.write(tr); to send these transactions down the TLM path.
  //Connected components with corresponding implementations receive the transaction via their write() methods.
  uvm_analysis_port #(adder_transaction) ap;

  virtual adder_if #(N) vif;

  // For change-detect (only emits when inputs change)
  //Store previous observed input values to detect changes.
  //Reason: Avoids flooding the analysis port with duplicate transactions when nothing has changed.
  bit [N-1:0] prev_A, prev_B;
  bit         have_prev = 0;

  function new(string name = "adder_monitor", uvm_component parent = null);
    super.new(name,parent);
    //Creates the analysis port and gives it a name ("ap") and parent handle (this).
    ap = new("ap", this);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual adder_if#(N))::get(this,"","vif",vif)) begin
        `uvm_fatal(get_type_name(), "Virtual interface 'vif' not set for adder_monitor")
    end
  endfunction : build_phase

  /*
  The monitor’s job is to:
  Wait until reset is over so it doesn’t record garbage values.
  Synchronize with the driver’s sampling point (@(vif.cb) — clocking block).
  Read the current DUT interface signals.
  Convert these raw pin values into a transaction (adder_txn).
  Send the transaction to the analysis port so the rest of the environment (scoreboard, coverage) can use it.
  Optionally filter duplicates (only emit when A or B change).
  */
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    wait_for_reset_release();

    //Keeps watching the DUT signals until simulation ends.
    forever begin
      //Ensures sampling happens at the same timing as the driver → avoids race conditions.
      @(vif.cb);

      //If DUT is currently under reset, skip this clock cycle.
      if(!vif.rst_n) begin
        continue;
      end

      //Reads the actual logic values from the DUT interface.
      a_now = vif.a;
      b_now = vif.b;
      sum_now = vif.sum;
      carry_now = vif.carry;

 
      if(vif.valid) begin
        //Don’t flood scoreboard with copies of the same transaction every clock.    First time 				(!have_prev) 		→ always record.Later → only record if A or B changes.
        if(!have_prev || (a_now!=prev_A) || (b_now!=prev_B) ) begin
  
          tr = adder_transaction::type_id::create("tr", this);

          //This is the "translation" from pin-level data → transaction-level model.
          tr.a = a_now;
          tr.b = b_now;
          tr.sum = sum_now;
          tr.carry = carry_now;

          //Sends the transaction (DUT output) to all subscribers(scoreboard) connected to the analysis 			port:
          ap.write(tr);

          prev_A = a_now;
          prev_B = b_now;
          have_prev = 1;
      	end
      end
    end
  endtask : run_phase

  task wait_for_reset_release();
    if (!vif.rst_n) begin
      @(posedge vif.rst_n);
    end
    @(posedge vif.clk);
  endtask : wait_for_reset_release



endclass : adder_monitor