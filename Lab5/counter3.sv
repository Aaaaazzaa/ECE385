module counter3 (	input Clk, enable,
						output logic [2:0] Q0);
always_ff @ (posedge Clk)
begin 
	if (enable)
		if (Q == 3'b111)
			Q <= 3'b000;
		else
			Q <= Q + 1;
end


endmodule