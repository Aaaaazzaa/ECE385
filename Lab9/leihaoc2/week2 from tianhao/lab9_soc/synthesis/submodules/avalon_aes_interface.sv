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
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);
	logic [31:0] RegFile[15:0];
	logic [31:0] writemask;
	always_comb
		begin
			if(AVL_READ & AVL_CS)
				begin
					AVL_READDATA = RegFile[AVL_ADDR];
				end
			else
				AVL_READDATA = 32'hffffffff;
		end
	assign EXPORT_DATA = {RegFile[0][31:16],RegFile[3][15:0]};
	always_ff @(posedge CLK)
		begin
			//bug: messed up with the bits of writemask
					unique case(AVL_BYTE_EN)
						4'b1111:
							writemask=32'hffffffff;
						4'b1100:
							writemask=32'hffff0000;
						4'b0011:
							writemask=32'h0000ffff;
						4'b1000:
							writemask=32'hff000000;
						4'b0100:
							writemask=32'h00ff0000;
						4'b0010:
							writemask=32'h0000ff00;
						4'b0001:
							writemask=32'h000000ff;
						default:
							writemask=32'b0;
					endcase

		//assign writemask = 32'hffffffff;
			if(AVL_WRITE & AVL_CS)
				begin 
					RegFile[AVL_ADDR] = AVL_WRITEDATA & writemask;
				end
			if(RESET)
				begin
					RegFile[0]=32'b1;
					RegFile[1]=32'b1;
					RegFile[2]=32'b1;
					RegFile[3]=32'b1;
					RegFile[4]=32'b1;
					RegFile[5]=32'b1;
					RegFile[6]=32'b1;
					RegFile[7]=32'b1;
					RegFile[8]=32'b1;
					RegFile[9]=32'b1;
					RegFile[10]=32'b1;
					RegFile[11]=32'b1;
					RegFile[12]=32'b1;
					RegFile[13]=32'b1;
					RegFile[14]=32'b1;
					RegFile[15]=32'b1;
				end
		end
endmodule
