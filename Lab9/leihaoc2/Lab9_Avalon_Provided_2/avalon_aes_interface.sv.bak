/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,

	// Avalon Reset Input
	input logic RESET,

	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data

	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs // keys?
);
	logic [31:0] RegFile [16];
	logic [31:0] maskW;
	// write
	always_comb begin
		unique case(AVL_BYTE_EN) begin
			4'b1111:
				maskW = 32'hffff;
			4'b1100:
				maskW = 32'hff00;
			4'b0011:
				maskW = 32'h00ff;
			4'b1000:
				maskW = 32'hf000;
			4'b0100:
				maskW = 32'h0f00;
			4'b0010:
				maskW = 32'h00f0;
			4'b0001:
				maskW = 32'h000f;
			default:
				maskW = 32'h0;
		endcase
		if (AVL_READ & AVL_CS) begin  // masked write
			RegFile[AVL_ADDR] = AVL_WRITEDATA & maskW;
		end
		else if (AVL_READ & AVL_CS) begin // normal read
			EXPORT_DATA = RegFile[AVL_ADDR];
		end
	end

endmodule
