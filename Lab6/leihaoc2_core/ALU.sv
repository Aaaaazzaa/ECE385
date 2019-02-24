module ALU(	input logic [1:0] ALUK,
				input logic [15:0] A, B,
				output logic [15:0] result
				);
				// add 00, and 01, not 10, passa 11
				always_comb begin
					unique case (ALUK)
						2'b00:
							result = A + B;
						2'b01:
							result = A & B;
						2'b10:
							result = ~A; 
						2'b11:
							result = A;
					endcase
				end



endmodule
