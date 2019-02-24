module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1
timeprecision 1ns;

// These signals are internal because the processor will be
// instantiated as a submodule in testbench.
logic [15:0] S;
logic Clk, Reset, Run, Continue;
logic [19:0] ADDR;
logic CE, UB, LB, OE, WE;
logic [11:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
wire [15:0] Data;
logic [15:0] PC, MAR,IR,MDR;
logic [15:0] R0_interal, R1_interal, R2_interal, R3_interal, R5_interal, R7_interal;
logic [15:0] Mem_Addr16;
logic LDReg, LDReg_FSM, Ben_interal;
logic [2:0] DestReg, BaseReg;
logic [5:0] state;
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
lab6_toplevel tp(.*);

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

always begin : INTERNAL_MONITORING
#2 PC=tp.my_slc.d0.PC;
MAR=tp.my_slc.d0.MAR;
MDR=tp.my_slc.d0.MDR;
IR=tp.my_slc.d0.IR;
R0_interal = tp.my_slc.d0.REGFILE_inst.Reg_Out[0];
R1_interal = tp.my_slc.d0.REGFILE_inst.Reg_Out[1];
R2_interal = tp.my_slc.d0.REGFILE_inst.Reg_Out[2];
R3_interal = tp.my_slc.d0.REGFILE_inst.Reg_Out[3];
R5_interal = tp.my_slc.d0.REGFILE_inst.Reg_Out[5];
R7_interal = tp.my_slc.d0.REGFILE_inst.Reg_Out[7];
Mem_Addr16 =  tp.my_test_memory.mem_array[16];
LDReg = tp.my_slc.d0.LD_REG;
DestReg = tp.my_slc.d0.DRMUX_Out;
BaseReg = tp.my_slc.d0.REGFILE_inst.SR1MUX_Out;
LDReg_FSM = tp.my_slc.state_controller.LD_REG;
state = tp.my_slc.state_controller.State;
Ben_interal = tp.my_slc.BEN;
end
//#2
initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
S = 16'h005a;		// Toggle Rest
Reset = 0;
Run = 1;
Continue = 1;

#2 Reset = 1;
	 Run = 0;
#2 Run = 1;

#50 S = 16'h00;

#6 Continue = 0;
#2 Continue = 1;

#6 Continue = 0;
#2 Continue = 1;

#6 Continue = 0;
#2 Continue = 1;

#6 Continue = 0;
#2 Continue = 1;

#6 Continue = 0;
#2 Continue = 1;

#6 Continue = 0;
#2 Continue = 1;

#6 Continue = 0;
#2 Continue = 1;

#6 Continue = 0;
#2 Continue = 1;

end
endmodule
