module testbench2();
timeunit 10ns;

timeprecision 1ns;
logic Clk = 0;
logic BCLK4 = 0;

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

always begin : CLOCK_GENERATION2
#8333 BCLK4 = ~ BCLK4; // 48kHz
end

logic signed [31:0] soundIn [480];

initial begin: CLOCK_INITIALIZATION
   Clk = 0;
   BCLK4 = 0;
   for (int i = 0; i < 480; i++) begin
     soundIn[i] = i * 2;
//     if (i > 9'd200)
//       soundIn[i] = i - 9'd330;
//     if (i > 9'd350)
//      soundIn[i] = i - 9'd430;
   end
end

logic Reset_h,  interDoneIN, arrDoneIN,  inBlock, nUpdateIN, ClearIN, DoneIN, mUpdateIN, storeIN;
logic [3:0] stateIn;
logic [9:0] mIN;
logic [9:0] nIN;
logic [8:0] bclkCnt;
logic [13:0] pitch;
logic [62:0] singleMultIn;
logic  [71:0] singleSumIn;
//logic [70:0] fout [959];
always_ff @ (posedge BCLK4) begin
	if (bclkCnt >= 10'd480 || Reset_h) begin
		bclkCnt = 10'd0;
	end
	else begin
		bclkCnt += 10'd1;
	end
end

assign inBlock = ~(bclkCnt == 10'd479);


autoConvolution inst(.*);


always_comb begin : INTERNAL_MONITORING
  stateIn = inst.smInst.fstate;
  interDoneIN = inst.smInst.interDone;
  arrDoneIN =  inst.smInst.arrDone;
  nUpdateIN = inst.smInst.nUpdate;
  ClearIN = inst.smInst.Clear;
  DoneIN = inst.smInst.Done;
  mUpdateIN = inst.smInst.mUpdate;
//  mIN = inst.m;
//  nIN = inst.n;
  storeIN = inst.store;
  singleMultIn = inst.singleMult;
  singleSumIn = inst.singleSum;
end

initial begin: TEST_VECTORS
#2 Reset_h = 1'b1;
#2 Reset_h = 1'b0;

end
endmodule
// module testbench2();
//   timeunit 10ns;
//
//   timeprecision 1ns;
//   logic Clk = 0;
//   always begin : CLOCK_GENERATION
//   #1 Clk = ~Clk;
//   end
//   logic [31:0] A, B;
//  logic [62:0] ans;
//  signedMult inst(.*);
//  initial begin: TEST_VECTORS
//  #2 A = 32'hA5;
//     B = 32'h74;
//  #2 A = 32'd56;
//     B = -32'd104;
// #2  A = -32'd56;
//     B = 32'd104;
// #2  A = -32'd56;
//     B = -32'd104;
// #2  A = 32'hFFFFFFFF;
//     B = 32'hFFFFFFFF;
// #2  A = 32'h7FFFFFFF;
//     B = 32'h7FFFFFFF;
//
//  end
//  endmodule
