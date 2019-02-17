module datapath (	input logic LD_MAR, 
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
						inout logic[15:0]	MDR,
												MDR_In,
						
						
						
						
						
						
						
						output logic [15:0]	PC, 
													MAR,
													IR
						);
	
						// FSM MemIO Tristate are given 
						// send signal to use them
						// changing MDR MAR is control by this module
						// pyhical mem interaction happens here
	logic [15:0] BUS;
//	enum logic {GatePC, GateMDR, GateALU,GateMARMUX} GateSig;
//	unique case(GateSig) begin
	always_comb begin
		if      (GatePC  & ~GateMDR & ~GateALU & ~GateMARMUX)
			BUS = PC;
		else if (~GatePC & GateMDR  & ~GateALU & ~GateMARMUX)
			BUS = MDR;
		else if (~GatePC & ~GateMDR & GateALU  & ~GateMARMUX)
			BUS = 16'h0000; // week2
		else if (~GatePC & ~GateMDR & ~GateALU & GateMARMUX)
			BUS = 16'h0000; // week2
		else 
			BUS = 16'bXXXXXXXXXXXXXXXX;
	end
	
	always_comb begin
		if (LD_MAR)
			MAR = BUS;
		else if(LD_MDR & MIO_EN) //week2 store
		// MIO_EN or ~MIO_EN
			MDR = MDR_In;
		else if(LD_IR)
			IR = BUS;
	end
		
						
						
	
endmodule	