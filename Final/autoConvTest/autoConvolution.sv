module autoConvolution
                        ( input logic BCLK4, Clk, Reset_h, inBlock,
                        input logic [8:0] bclkCnt,
                        input logic [31:0] soundIn [480],
                        output logic [70:0] fout [959] // 2^31 * 2^31 * 1920; len = 2 * 1920 -1
                        );
logic interDone, arrDone, nUpdate, Clear, Done, mUpdate, store;
reg unsigned [9 : 0] n;
reg signed [9 : 0] m;
reg signed [70:0] singleSum;
logic signed [31:0] fn_m, fm;
logic signed [62:0] singleMult;
assign fn_m = (n >= m + 10'd1 && n <= 10'd480 + m) ? soundIn[n-m-10'd1] : 32'd0;
assign fm = (m >= 10'd0 && m <= 10'd479) ? soundIn[m] : 32'd0;


signedMult multInst(.A(fn_m), .B(fm), .ans(singleMult));
always_ff @ (posedge Clk) begin
  if (Clear)
   singleSum <= 70'd0;
  else if(mUpdate)
    singleSum <= singleSum + singleMult;
end

always_ff @ (posedge Clk) begin
  if (Reset_h) begin
    n <= 10'd0;
    m <= -10'd480;
  end
  if (Clear) begin
    m <= -10'd480;
  end
  if (nUpdate) begin
    n <= n + 10'd1;
  end
  if (mUpdate) begin
    m <= m + 10'd1;
  end
  if (store && n <= 10'd960) begin // avoid out of boundary
    fout[n-10'd1] <= singleSum;
  end
end

assign arrDone = (n == 10'd960); // arr has len 3890
assign interDone = (m == 10'd479); // do summation for m [-1920, 1919]
convolutionSM smInst(.reset(Reset_h), .clock(Clk), .*);



endmodule
