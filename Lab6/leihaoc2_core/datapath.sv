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
						input logic[1:0] PCMUX,ADDR2MUX, ALUK,
						input logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX,
						// above FSM's output
						input logic[15:0]	MDR_In,



						output logic [15:0]	PC,
													MAR,
													IR,
													MDR,
						output logic BEN
						);

						// FSM MemIO Tristate are given
						// send signal to use them
						// changing MDR MAR is control by this module
						// pyhical mem interaction happens here
	logic [15:0] BUS, PC_out_PCMUX, MDR_out_MUX;
	logic [15:0] SR1_Out, SR2_Out, SR2MUX_Out, SEXTIR4; // output of regfile, use this
	// SR1_Out _yes_; SR2_Out yes__
	logic [2:0] DRMUX_Out;
	logic [2:0] SR1MUX_Out;
	logic [15:0] AddrGen_Out; // output of addrgen, use this
	logic N, Z, P;
	logic [15:0] result; // result of ALU, use this

	always_comb begin // BUS MUX // In : GateSig controlled PC/ALU/MDR/MAR; Out: BUS
	unique case({GatePC, GateMDR, GateALU, GateMARMUX})
		4'b1000:
		// MAR <- PC
			BUS = PC;
		4'b0100:
		// IR <- MDR
			BUS = MDR; // BUG: MDR_In
		4'b0010:
			BUS = result;
		4'b0001:
			BUS = AddrGen_Out;
		default:
			BUS = 16'bXXXXXXXXXXXXXXXX;
		endcase
	end


	always_comb begin // MDR MUX In: BUS, Data_to_CPU = MDR_In; Out = MUX out
	if (MIO_EN)
		MDR_out_MUX = MDR_In;
	else
		MDR_out_MUX = BUS;
	end

	bit16Reg reg_PC  (.Clk, .Reset, .LdEn(LD_PC),  .In(PC_out_PCMUX), .Out(PC));
	bit16Reg reg_IR  (.Clk, .Reset, .LdEn(LD_IR),  .In(BUS), 			.Out(IR));
	bit16Reg reg_MDR (.Clk, .Reset, .LdEn(LD_MDR), .In(MDR_out_MUX),	.Out(MDR));
	bit16Reg reg_MAR (.Clk, .Reset, .LdEn(LD_MAR), .In(BUS), 			.Out(MAR));

	// Start of (Blue) Reg File

			// implied DRMUX
			always_comb begin
				case (DRMUX)
					1'b0:
						DRMUX_Out = IR[11:9];
					1'b1:
						DRMUX_Out = 3'b111;
				endcase
			end


			// implied SR1MUX
			always_comb begin
				case (SR1MUX)
					1'b0:
						SR1MUX_Out = IR[8:6];
					1'b1:
						SR1MUX_Out = IR[11:9];
				endcase
			end


			RegFile REGFILE_inst(.LD_REG, .Clk, .Reset, .Reg_In(BUS), .DRMUX_Out, .SR2(IR[2:0]), .SR1MUX_Out, .SR1_Out, .SR2_Out );
	// End of (Blue) Reg File


	// Start of (Pink) PCGen
			PCGenerator PC_inst(.*, .PC_in_PCMUX(PC), .PC_out_PCMUX); //week2
	// End of (Pink) PCGen


	// Start of (Green) AddrGen

			AddrGenerator Addr_inst(.*, .Addr_Out(AddrGen_Out));
	// End of (Green) AddrGen



	// Start of (Purple) setCC

			setCC setCC_inst(.*, .basis(BUS));
			always_ff @ (posedge Clk) begin
				if(LD_BEN) begin
					BEN = (IR[11] & N) | (IR[10] & Z) | (IR[9] & P);
				end
				else begin
					// empty
				end
			end

	// End of (Purple) setCC

	// start of (yellow) ALU
			ALU ALU_inst (.ALUK, .A(SR1_Out), .B(SR2MUX_Out), .result);
	// end of (yellow) ALU

	// Start of (Red)
			// implied SR2MUX
			SEXT #(4) sext4_inst (IR[4:0], SEXTIR4);
			always_comb begin
				if(SR2MUX)
					SR2MUX_Out = SEXTIR4;
				else
					SR2MUX_Out = SR2_Out;
			end
	// End of (Red)

endmodule
