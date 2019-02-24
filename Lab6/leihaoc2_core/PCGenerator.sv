module PCGenerator( 	input logic[1:0] 	PCMUX,
							input logic[15:0] 	PC_in_PCMUX, BUS, AddrGen_Out,
							output logic[15:0] 	PC_out_PCMUX
							);
							// implied PCMUX
	always_comb begin
		case (PCMUX) // week2
			2'b00:
			 PC_out_PCMUX = PC_in_PCMUX + 1;
			2'b01:
			 PC_out_PCMUX = AddrGen_Out; // week2
			2'b10:
			 PC_out_PCMUX = BUS;
			default:
			 PC_out_PCMUX = 16'hffff;
		endcase
	end
endmodule
