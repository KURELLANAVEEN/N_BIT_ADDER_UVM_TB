module n_bit_adder #( parameter N = 4) (
  input logic [N-1:0] A,
  input logic [N-1:0] B,
  output logic [N-1:0] SUM,
  output logic CARRY
);
  logic [N-1:0] C;

  // 1 half adder for addition of LSB
  half_adder HA (.a(A[0]), .b(B[0]), .sum(SUM[0]), .carry(C[0]));

  // rest n-1 bits using full adder
  genvar i;
  for (i=1; i<N; i++) begin
    full_adder FA (.a(A[i]), .b(B[i]), .cin(C[i-1]), .sum([SUM[i]]), .carry(C[i]));
  end

  assign CARRY = C[N-1];

endmodule