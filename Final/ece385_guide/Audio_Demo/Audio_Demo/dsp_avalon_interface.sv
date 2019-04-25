///************************************************************************
//Avalon-MM Interface for AES Decryption IP Core
//
//Dong Kai Wang, Fall 2017
//
//For use with ECE 385 Experiment 9
//University of Illinois ECE Department
//
//Register Map:
//
// 0-3 : 4x 32bit AES Key
// 4-7 : 4x 32bit AES Encrypted Message
// 8-11: 4x 32bit AES Decrypted Message
//   12: Not Used
//	13: Not Used
//   14: 32bit Start Register
//   15: 32bit Done Register
//
//************************************************************************/
//
//module dsp_aes_interface (
//	// Avalon Clock Input
//	input logic CLOCK_50,
//  input	logic	CLOCK_27,
//	// Avalon Reset Input
//	input logic RESET,
//  input	logic	[3:0]	KEY,
//  input	logic	[3:0]	SW,
//	// Avalon-MM Slave Signals
//	input  logic AVL_READ,					// Avalon-MM Read
//	input  logic AVL_WRITE,					// Avalon-MM Write
//	input  logic AVL_CS,						// Avalon-MM Chip Select
//	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
//	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
//	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
//	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
//
//
//  input	logic			AUD_ADCDAT,
//  input logic [31:0] EXP_SOUNDIN,
//	// Exported Conduit
//	output logic [31:0] EXPORT_DATA,		// Exported Conduit Signal to LED
//  // Bidirectionals
//  inout	logic 			AUD_BCLK,
//  inout	logic			AUD_ADCLRCK,
//  inout	logic	AUD_DACLRCK,
//
//  inout	logic	I2C_SDAT,
//
//  // Outputs
//  output logic	AUD_XCK,
//  output logic	AUD_DACDAT,
//
//  output logic	I2C_SCLK,
//  output 		[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX4, HEX5, HEX6, HEX7,
//  output 		[8:0] LEDG
//);
//	logic [31:0] RegFile[4];
//  // TODO: sm for blockization
//
//	always_comb	begin
//			if(AVL_READ & AVL_CS)
//				begin
//					AVL_READDATA = RegFile[AVL_ADDR];
//				end
//			else
//				AVL_READDATA = 32'hffffffff;
//	end
//
//	// TODO assign EXPORT_DATA =  RegFile[8];//{RegFile[0][31:16],RegFile[3][15:0]};
//	always_ff @(posedge CLK)
//		begin
//		// default
//		RegFile[0] = EXP_SOUNDIN;
//			if(AVL_WRITE & AVL_CS)
//				begin
//					RegFile[AVL_ADDR] = AVL_WRITEDATA;
//				end
//			if(RESET)
//				begin
//					RegFile[0]=32'b0;
//					RegFile[1]=32'b0;
//					RegFile[2]=32'b0;
//					RegFile[3]=32'b0;
//				end
//		end
//endmodule
