/*
The UVM environment is the “container” that brings together, organizes, and manages all the verification components needed to check your DUT, making testbenches more modular, reusable, scalable, and maintainable. It’s the backbone of any UVM testbench.
*/

class adder_env extends uvm_env;
  `uvm_component_utils(adder_env)

  adder_agent      agent_h;     
  adder_scoreboard scoreboard_h;

  function new(string name = "adder_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent_h = adder_agent::type_id::create("agent_h", this);
    scoreboard_h = adder_scoreboard::type_id::create("scoreboard_h", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //Wires the agent’s analysis_export (driven by the monitor's ap) to the scoreboard’s analysis_export (uvm_analysis_imp).
    agent_h.analysis_export.connect(scoreboard_h.mon_imp);

  endfunction : connect_phase

endclass : adder_env