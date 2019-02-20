module testbench();
timeunit 10ns; // Half clock cycle at 50 MHz
   // This is the amount of time represented by #1
timeprecision 1ns;
// These signals are internal because the processor will be
// instantiated as a submodule in testbench.
//       input logic [7:0]S,
//       input logic Clk, Reset, ClearA_LoadB, Exe,
//       
//       //output logic [7:0]Bval,
//       output logic X,
//       output logic [15:0]result
logic Clk = 0;
logic Reset, Exe, ClearA_LoadB, X;
logic [15:0] result;
logic [16:0] XAB;
logic [7:0] S;
Lab5_toplevel inst(.S, .Clk, .Reset(Reset), .ClearA_LoadB(ClearA_LoadB), .Run(Exe), .result, .X); 
// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end
initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end

logic [7:0] A,B;
logic Shift, Add, Sub;

always_comb
begin
	X <= inst.mult_inst.X;
	A <= inst.mult_inst.A_;
	B <= inst.mult_inst.B_;
	Shift <= inst.mult_inst.Shift;
	Add <= inst.mult_inst.Add;
	Sub <= inst.mult_inst.Sub;
end
assign XAB = {X,A,B};
initial begin: TEST_VECTORS
Reset = 1;
ClearA_LoadB = 1;
Exe = 1;
//S = 8'b11000101;
S = 8'hAC;
#2 Reset = 0;
#2 Reset = 1;
#2 ClearA_LoadB = 0; 
#2 ClearA_LoadB = 1;
//S = 8'h0007;
S = 8'hAC;


#2 Exe = 0;  
#20 Exe = 1;

//#2 Exe = 0;  
//#20 Exe = 1;
//
//#2 Exe = 0;  
//#20 Exe = 1;
//
//#2 Exe = 0;  
//#20 Exe = 1;
//
//#2 Exe = 0;  
//#20 Exe = 1;
//
//#2 Exe = 1;
//#32 Exe = 0;
#2 Exe = 1;
end
endmodule

