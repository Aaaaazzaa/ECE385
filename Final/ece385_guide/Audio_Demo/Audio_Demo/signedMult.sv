module signedMult ( input logic [31:0] A, B,
                    output logic [62:0] ans);
  logic [31:0] absA, absB;
  logic neg;
  assign neg = A[31] ^ B[31];
  assign absA = (A[31]) ? (~A + 32'd1) : A;
  assign absB = (B[31]) ? (~B + 32'd1) : B;

  always_comb begin
    if (neg)
      ans = ~({31'd0, absA} * {31'd0, absB}) + 63'd1;
    else
      ans = {31'd0, absA} * {31'd0, absB};
  end



endmodule
