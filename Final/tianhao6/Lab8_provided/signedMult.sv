module signedMult10 ( input logic [9:0] A, B,
                    output logic [19:0] ans);
  logic [9:0] absA, absB;
  logic neg;
  assign neg = A[9] ^ B[9];
  assign absA = (A[9]) ? (~A + 10'd1) : A;
  assign absB = (B[9]) ? (~B + 10'd1) : B;

  always_comb begin
    if (neg)
      ans = ~({10'd0, absA} * {10'd0, absB}) + 20'd1;
    else
      ans = {10'd0, absA} * {10'd0, absB};
  end



endmodule
