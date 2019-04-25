module autoConvolution
                        ( input logic BCLK4, Clk, Reset_h, inBlock,
                        input logic [8:0] bclkCnt,
                        input logic signed [31:0] soundIn [480],
                        output logic [13:0] pitch // 2^31 * 2^31 * 1920; len = 2 * 1920 -1
                        );
logic interDone, arrDone, nUpdate, Clear, Done, mUpdate, store;
reg signed [9 : 0] l;
reg signed [9 : 0] n;
reg signed [71:0] singleSum;
logic signed [31:0] fn_l, fn;
logic signed [62:0] singleMult;
logic signed [71:0] fout [480];
// m-n-1 % 480
logic [9:0] nMod, n_lMod;
assign fn_l = soundIn[n_lMod];
assign fn = soundIn[nMod];

signedMod mod0(.num(n-l+10'd1), .base(10'd480), .result(n_lMod));
signedMod mod1(.num(n), .base(10'd480), .result(nMod));


signedMult multInst(.A(fn_l), .B(fn), .ans(singleMult));
always_ff @ (posedge Clk) begin
  if (Clear)
   singleSum <= 72'd0;
  else if(mUpdate)
    singleSum <= singleSum + {9'd0,singleMult};
end

always_ff @ (posedge Clk) begin
  if (Reset_h) begin
    n <= 10'd0;
    l <= 10'd0;
  end
  if (Clear) begin
    n <= 10'd0;
  end
  if (nUpdate) begin
    l <= l + 10'd1;
  end
  if (mUpdate) begin
    n <= n + 10'd1;
  end
  if (store && l < 10'd480) begin // avoid out of boundary
    fout[l-10'd1] <= singleSum;
  end
end

assign arrDone = (l == 10'd480); // arr has len 3890
assign interDone = (n == 10'd479); // do summation for m [-1920, 1919]
convolutionSM smInst(.reset(Reset_h), .clock(Clk), .*);

findMaxIdx findMaxInst(.fout, .shouldFind(Done), .Clk, .pitch );

endmodule
