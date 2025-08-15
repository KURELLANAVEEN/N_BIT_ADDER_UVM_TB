/*
The scoreboard's duty is to compare observed transactions from the monitor against expected values or a reference model to validate correct DUT behavior.
*/

class adder_scoreboard extends uvm_component;
  `uvm_component_utils(adder_scoreboard)

  // Simple bookkeeping
  int unsigned total_count;
  int unsigned pass_count;
  int unsigned fail_count;

  //In UVM, data is passed from producers (e.g., monitors) to consumers (e.g., scoreboards) using TLM analysis ports/exports/imps.
  //The scoreboard is a consumer, so it needs a TLM implementation port that has: A compatible type (adder_txn here). Knowledge of what method to call when data arrives.

  //First parameter (adder_txn) is the type of transaction it will receive.
  //Second parameter (adder_scoreboard) is the class that will implement the write() method.
  uvm_analysis_imp #(adder_transaction, adder_scoreboard) mon_imp;

  function new(string name = "adder_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    mon_imp = new("mon_imp", this);
    total_count = 0;
    pass_count  = 0;
    fail_count  = 0;
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

  // Write method called on every incoming transaction
  //The write() is the callback method that automatically executes whenever a matching transaction arrives from the connected port
  function void write(input adder_transaction tr);

    tr.calc_expected();

    total_count++;

    if( (tr.sum != tr.expected_sum) || (tr.carry != tr.expected_carry) ) begin
      fail_count++;
      `uvm_error(get_type_name(),
        $sformatf("Mismatch #%0d: A=%0d B=%0d | Exp SUM=%0b Carry=%0b | got SUM=%0b COUT=%0b",
                  total_count, tr.a, tr.b, tr.expected_sum, tr.expected_carry, tr.sum, tr.carry));
    end
    else begin
      pass_count++;
      `uvm_info(get_type_name(),
                $sformatf("Match #%0d: A=%0d B=%0d SUM=%0b COUT=%0b Observed Total=%0d",total_count, tr.a, tr.b, tr.sum, tr.carry, {tr.carry, tr.sum}), UVM_MEDIUM);
    end 

  endfunction : write

  // Summary at report phase (or end_of_simulation)
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);

    // Fail the test if any mismatches were seen
    if (fail_count > 0) begin
      `uvm_error(get_type_name(),
                 $sformatf("***[FAIL]*** Scoreboard detected %0d mismatches", fail_count));
    end
    else begin
      `uvm_info(get_type_name(), $sformatf("***[PASS]*** Scoreboard summary: Total Stimulus Input=%0d Pass=%0d Fail=%0d",
            total_count, pass_count, fail_count), UVM_LOW);
    end
  endfunction : report_phase

endclass