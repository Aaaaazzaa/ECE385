module test(input logic [3:0] num1,
				input logic [3:0] num2,
				input logic Clk,
				output logic [65535:0] result);
				logic [3:0] inter;
//			always_ff @ (posedge Clk)
//				result = num1 << 2;
				logic [3:0] color[307200];
			assign result = num1 + num2;
endmodule 