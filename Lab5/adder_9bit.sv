module adder_9bit(	input logic [8:0]S, Ai,
							input logic Cin,
							output logic [7:0]Ao, // Set Ao to 7 
							output logic X,C); // Seperate result into 1+8 bit
	logic Carry;
	ADDER8 A80(.A(S[7:0]),	.B(Ai[7:0]),	.cin(Cin),	.S(Ao[7:0]),	.cout(Carry));
	full_adder fa(.x(Ai[8]),	.y(S[8]),	.z(Carry),	.s(X),	.c(C));
	// X ?
							
endmodule

module full_adder (input x, y, z,
						 output logic s, c);
						 assign s = x^y^z;
						 assign c = (x&y)|(y&z)|(x&z);
endmodule

module ADDER4 (input [3:0] A, B,
					input c_in,
					output logic [3:0] S,
					output logic c_out);
					// Internal carries in the 4-bit adder
					logic c0, c1, c2;
					/*============================================*/
					// Netlists with named (explicit) port connection
					// Syntax: <module> <name>(.<parameter_name> (<connection_name>), …)
					full_adder FA0 (.x (A[0]), .y (B[0]), .z (c_in), .s (S[0]), .c (c0));
					full_adder FA1 (.x (A[1]), .y (B[1]), .z (c0), .s (S[1]), .c (c1));
					full_adder FA2 (.x (A[2]), .y (B[2]), .z (c1), .s (S[2]), .c (c2));
					full_adder FA3 (.x (A[3]), .y (B[3]), .z (c2), .s (S[3]), .c (c_out));
endmodule

module ADDER8(input [7:0] A, B,
				  input cin,
				  output logic [7:0] S,
				  output logic cout);
				  logic c;
				  ADDER4 A40(.A(A[3:0]),	.B(B[3:0]),	.c_in(cin),	.S(S[3:0]),	.c_out(c));
				  ADDER4 A41(.A(A[7:4]),	.B(B[7:4]),	.c_in(c),	.S(S[7:4]),	.c_out(cout));
endmodule
