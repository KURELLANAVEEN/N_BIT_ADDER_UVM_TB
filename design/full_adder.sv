module full_adder(
  input logic a,
  input logic b,
  input logic cin,
  output logic sum,
  output logic carry
);

// We instantiate two half adders for full adder.
  logic sum1, carry1;
  half_adder HA_1 (.a(a), .b(b), .sum(sum1), .carry(carry1));

  logic carry2;
  half_adder HA_2 (.a(sum1), .b(cin), .sum(sum), .carry(carry2));

  assign carry = carry1 | carry2;

endmodule : full_adder

