module datapath (	input logic Clk,
										LD_MAR, 
										LD_MDR, 
										LD_IR, 
										LD_BEN, 
										LD_CC, 
										LD_REG, 
										LD_PC, 
										LD_LED,
										GatePC, 
										GateMDR, 
										GateALU, 
										GateMARMUX,
										MIO_EN,
										Reset,
						input logic[1:0] PCMUX,
										
										
						input logic[15:0]	MDR_In,
						
						
						
						output logic [15:0]	PC, 
													MAR,
													IR,
													MDR
						);
	
						// FSM MemIO Tristate are given 
						// send signal to use them
						// changing MDR MAR is control by this module
						// pyhical mem interaction happens here
	logic [15:0] BUS, PC_out_PCMUX, MDR_out_MUX;

	always_comb begin // BUS MUX // In : GateSig controlled PC/ALU/MDR/MAR; Out: BUS
		if      (GatePC  & ~GateMDR & ~GateALU & ~GateMARMUX)
		// MAR <- PC
			BUS = PC;
		else if (~GatePC & GateMDR  & ~GateALU & ~GateMARMUX)
		// IR <- MDR
			BUS = MDR_In;
		else if (~GatePC & ~GateMDR & GateALU  & ~GateMARMUX)
			BUS = 16'h0000; // week2
		else if (~GatePC & ~GateMDR & ~GateALU & GateMARMUX)
			BUS = 16'h0000; // week2
		else 
			BUS = 16'bXXXXXXXXXXXXXXXX;
	end
	
	always_comb begin // MDR MUX In: BUS, Data_to_CPU = MDR_In; Out = MUX out
	if (MIO_EN)
		MDR_out_MUX = MDR_In;
	else
		MDR_out_MUX = 16'h0000; // week2
	end 
	PCGenerator (.PCMUX, .PC_in_PCMUX(PC), .PC_out_PCMUX); //week2
	bit16Reg reg_PC  (.Clk, .Reset, .LdEn(LD_PC),  .In(PC_out_PCMUX), .Out(PC));
	bit16Reg reg_IR  (.Clk, .Reset, .LdEn(LD_IR),  .In(BUS), 			.Out(IR));
	bit16Reg reg_MDR (.Clk, .Reset, .LdEn(LD_MDR), .In(MDR_out_MUX),	.Out(MDR));
	bit16Reg reg_MAR (.Clk, .Reset, .LdEn(LD_MAR), .In(BUS), 			.Out(MAR));
	
						
						
	
endmodule	