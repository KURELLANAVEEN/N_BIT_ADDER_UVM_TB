/*
The UVM test is the top-level user-defined component in the UVM testbench hierarchy.
It acts as the “main program” for your verification, bringing together the environment and controlling test execution.
Multiple tests can reuse the same environment and bench; only the test code changes to check different features or corner cases.
*/

class adder_base_test extends uvm_test;
  `uvm_component_utils(adder_base_test)

  adder_env env_h;
  adder_random_sequence random_seq_h;
  adder_corner_sequence corner_seq_h;

  function new(string name = "adder_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env_h = adder_env::type_id::create("env_h", this);

    /*
    uvm_config_db#(virtual adder_if#(N))::set(this, "env_h.agent_h", "vif", tb_top.dut_if);
    */

    uvm_config_db#(uvm_active_passive_enum)::set(this, "env_h.agent_h", "is_active", UVM_ACTIVE);

  endfunction : build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    random_seq_h = adder_random_sequence::type_id::create("random_seq_h");
    corner_seq_h = adder_corner_sequence::type_id::create("corner_seq_h");

    random_seq_h.start(env_h.agent_h.seqr_h);
    corner_seq_h.start(env_h.agent_h.seqr_h);
    phase.drop_objection(this);
  endtask
endclass