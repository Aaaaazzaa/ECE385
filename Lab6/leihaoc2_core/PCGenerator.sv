module PCGenerator( 	input logic[1:0] 	PCMUX,
							input logic[15:0] 	PC_in_PCMUX,
									// week2
							output logic[15:0] 	PC_out_PCMUX
							);
	always_comb begin
		if (PCMUX == 2'b00) // week2
		 PC_out_PCMUX = PC_in_PCMUX + 1;
		else
		 PC_out_PCMUX = 16'hffff; // week2
	end
endmodule
