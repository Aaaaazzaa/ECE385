module bit16Reg(input logic Clk, Reset, LdEn,
					  input logic [15:0] In,
					  output logic [15:0] Out
					  );
					  always_ff @(posedge Clk)
					  begin 
						if(~Reset)
							begin 
								Out<=16'b0;
							end
						else if(LdEn)
							begin
								Out<=In;
							end
						end
endmodule 