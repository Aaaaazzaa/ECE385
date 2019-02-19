module Multiplier (	input logic [7:0]S,
							input logic Clk, Reset, ClearA_LoadB, Exe,
							
							output logic [7:0] Aval, Bval,
							output logic X,
							output logic [15:0]result);
													
// Hexdiver and switch


	
// Given defined modules: counter3, reg_8, operation, state
// put everthing together
logic Add, Sub, Clr_Ld, M, Shift, Aso, X_tmp; // X_ to distinguish output X, Aso = A_Shift_Out (redirect to B_Shift_In)
logic [7:0] A_, B_, Dain, Dbin, A_tmp; // OpRe result of operation module
// state machine


// Shift Register A, B

reg_8 RegA (	.Clk, .Reset(ClearA_LoadB | Clr_Ld), .Shift_In(A_[7]), .Load(Add | Sub), .Shift_En(Shift), .D(Dain),
				.Shift_Out(Aso), .Data_Out(A_)); // A parallel load input
				
reg_8 RegB (	.Clk, .Reset(Reset), .Shift_In(Aso), .Load(ClearA_LoadB), .Shift_En(Shift), .D(S),
				.Shift_Out(), .Data_Out(B_));
				
state FSM ( .reset(Reset), .clock(Clk), .M(B_[0]), .Exe,
				.Shift, .Add, .Sub, .Clr_Ld);

// FSM unsure ouputs what when unsigned (assume 0)								
operation main(.Add(Add), .Sub(Sub), .A(A_), .S, .NewA(Dain), .NewX()); //


assign result = {A_, B_};

endmodule 