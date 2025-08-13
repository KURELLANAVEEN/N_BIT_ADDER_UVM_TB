/*
agent encapsulates and organizes the main verification components required to drive stimulus and monitor the DUT interface.
Agents can be either:
Active (includes driver, sequencer, monitor)
Passive (only monitor, no stimulus driving)
*/
import adder_tb_pkg::*;
class adder_agent extends uvm_agent;
  `uvm_component_utils(adder_agent)

  //Active or passive agent (default active). Default is active, but it can be overridden via UVM config DB.
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  adder_sequencer  seqr_h;
  adder_driver     drv_h;
  adder_monitor    mon_h;

  //This port exports the transactions observed by the monitor outside the agent (e.g., to the environment or scoreboard).
  //It acts as a conduit to broadcast DUT interface transactions from the monitor to other verification components.
  uvm_analysis_export #(adder_transaction) analysis_export;

  virtual adder_if #(N) vif;

  function new(string name = "adder_agent", uvm_component parent = null);
    super.new(name, parent);
    //Creates the analysis export port which will carry monitor transactions outside the agent.
    analysis_export = new("analysis_export", this);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    //
    void'(uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active));

    if (!uvm_config_db#(virtual adder_if#(N))::get(this, "", "vif", vif)) begin
      `uvm_fatal(get_type_name(), "Virtual interface 'vif' not found in config DB")
    end

    //Conditionally creates sequencer and driver if the agent is active.
    mon_h  = adder_monitor ::type_id::create("mon_h",  this);

    if(is_active == UVM_ACTIVE) begin
      seqr_h = adder_sequencer::type_id::create("seqr_h", this);
      drv_h  = adder_driver   ::type_id::create("drv_h",  this);
    end

  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    //mon.ap is your monitor’s analysis_port (type uvm_analysis_port #(adder_txn)).

    //analysis_export is the agent’s analysis_export (type uvm_analysis_export #(adder_txn)).

    // connecting the monitor’s output (transactions it observes) to the agent’s output port.

    //The monitor produces transactions by calling ap.write(tr).

    //But if we want the environment or scoreboard to receive them, we need to expose them outside the agent.

    //The analysis_export acts like a re-routing point — it receives what the monitor sends and passes it outward to whoever connects to the agent.

    //This is TLM (Transaction Level Modeling) connection — it passes transaction objects (adder_txn) between components.
    mon_h.ap.connect(analysis_export);

    if (is_active == UVM_ACTIVE) begin

      //seq_item_port (in the driver) is a TLM port the driver uses to pull transactions from a sequencer.
      //seq_item_export (in the sequencer) is the matching port that outputs the transactions the sequencer manages.
      drv_h.seq_item_port.connect(seqr_h.seq_item_export);
    end
  endfunction : connect_phase

endclass : adder_agent