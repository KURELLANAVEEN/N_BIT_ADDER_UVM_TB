interface adder_if #( parameter N = 4) (input logic clk, input logic rst_n);

  // DUT signals
  logic [N-1 : 0] a, b;
  logic [N-1 : 0] sum;
  logic carry;

  // clocking block direction relative to TB
  clocking cb @(posedge clk);
    default input #1 output #1; //This delay avoid race condition b/w DUT & TB
    input sum, carry;
    output a, b;
  endclocking
  
endinterface