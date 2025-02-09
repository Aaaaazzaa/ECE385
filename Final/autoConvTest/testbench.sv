module testbench();
timeunit 10ns; // Half clock cycle at 50 MHz
   // This is the amount of time represented by #1
timeprecision 1ns;
logic Clk = 0;
logic VGA_CLK = 0;


//logic unsigned [2:0] stateInter;
//logic ClearInter, BufferWEInter, UpdateAddrInter, ReadDoneInter, VGA_BLANK_EX, Reset_h;
logic VGA_BLANK_EX, Reset_h; 
logic [19:0] testPt, bufferIdx;
logic [9:0] drawXIn, drawYIn;
//logic [19:0] AddrInter;
testTopLevel inst(.*);
//autoConvolution inst(.soundIn, .result);
always_comb begin : INTERNAL_MONITORING
//  AddrInter = inst.sramHandler.ADDR;
//  stateInter = inst.sramHandler.sramcontrollerInst.fstate;
//  ClearInter = inst.sramHandler.sramcontrollerInst.Clear;
//  BufferWEInter = inst.sramHandler.sramcontrollerInst.BufferWE;
//  UpdateAddrInter =  inst.sramHandler.sramcontrollerInst.UpdateAddr;
//  ReadDoneInter = inst.sramHandler.ReadDone;
//	Energy = inst.energy;
drawXIn = inst.DrawX;
drawYIn = inst.DrawY;
bufferIdx = inst.drawPtVGA;
end
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end
always begin : CLOCK_GENERATION2
#2 VGA_CLK = ~VGA_CLK; 
end
initial begin: CLOCK_INITIALIZATION
    Clk = 0;
	 VGA_CLK = 0;
//	 for (int i = 0; i < 16; i++) begin
//		/* code */
//		soundIn[i] = 11'd1; 
//	end
end

//always_comb begin
////flag = testinst.mem[1];
//end

initial begin: TEST_VECTORS
#2 Reset_h = 1'b1;
#2 Reset_h = 1'b0;

end
endmodule
