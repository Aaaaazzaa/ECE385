module test(input logic [3:0] num1,
				input logic [3:0] num2,
				input logic Clk,
				output logic [3:0] result);
				logic [3:0] inter;
			always_ff @ (posedge Clk)
				result = num1 << 2;
				
			//assign result = num1 - inter*num2;
endmodule 