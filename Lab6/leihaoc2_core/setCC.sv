module setCC(			input logic LD_CC, Clk,

							input logic [15:0] basis,
							output logic N, Z, P
				);
	always_ff @ (posedge Clk) begin
			if (LD_CC) begin
					if (basis == 16'h0000) begin
						N <= 1'b0;
						Z <= 1'b1;
						P <= 1'b0;
					end
					else if (basis[15] == 1'b0) begin
						N <= 1'b0;
						Z <= 1'b0;
						P <= 1'b1;
					end
					else begin
						N <= 1'b1;
						Z <= 1'b0;
						P <= 1'b0;
					end
				end
			else begin
			// 	N <= N;
			// 	Z <= Z;
			// 	P <= P;
			end
	end
endmodule
