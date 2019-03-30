module testbench();
timeunit 10ns; // Half clock cycle at 50 MHz
   // This is the amount of time represented by #1
timeprecision 1ns;
// These signals are internal because the processor will be
// instantiated as a submodule in testbench.
// toplevel signal
logic CLK = 0;
logic RESET;
logic AES_START;
logic AES_DONE;
logic [127:0] AES_KEY;
logic [127:0] AES_MSG_ENC;
logic [127:0] AES_MSG_DEC;
AES inst(.*);
// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 CLK = ~CLK;
end
initial begin: CLOCK_INITIALIZATION
    CLK = 0;
end
// test signal
logic [3:0]stateInII;
logic [3:0]roundIn;
logic [1:0] SelIn, IMCcntIn;
logic cycleIn, updataIn, StoreIn, IMCDoneIn, UpdateIMCIn;
logic [127:0] roundkeyIn, msgIn;
always_comb
begin
  stateInII = inst.sm.fstate;
  cycleIn = inst.Cycle;
  updataIn = inst.Update;
  roundIn = inst.round;
  SelIn = inst.Sel;
  StoreIn = inst.Store;
  roundkeyIn = inst.roundkey;
  msgIn = inst.msg;
  IMCcntIn = inst.IMCcnt;
  IMCDoneIn = inst.IMCDone;
  UpdateIMCIn = inst.UpdateIMC;
// 	X <= inst.mult_inst.X;
// 	A <= inst.mult_inst.A_;
// 	B <= inst.mult_inst.B_;
// 	Shift <= inst.mult_inst.Shift;
// 	Add <= inst.mult_inst.Add;
// 	Sub <= inst.mult_inst.Sub;
end
initial begin: TEST_VECTORS
#2 RESET = 1;
#2  RESET = 0;
    AES_KEY = 128'h0001_0203_0405_0607_0809_0a0b_0c0d_0e0f;
    AES_MSG_ENC = 128'hdaec_3055_df05_8e1c_39e8_14ea_76f6_747e;
#20 // wait for KeySchedule
#2 AES_START = 0;
#2 AES_START = 1;

#2 AES_START = 0;

#200  AES_KEY = 128'h3b280014beaac269d613a16bfdc2be03;
      AES_MSG_ENC = 128'h439d619920ce415661019634f59fcf63;
#20 // wait for KeySchedule
#2 AES_START = 0;
#2 AES_START = 1;
end
endmodule
