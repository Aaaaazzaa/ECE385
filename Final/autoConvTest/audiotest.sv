
`include "audio_interface.vhd"
module audiotest(	input logic reset, Clk,
						input logic  INIT_FINISH, adc_full, data_over, AUD_MCLK, AUD_DACDAT, I2C_SDAT, I2C_SCLK,
						input logic [31:0] ADCDATA,
						output logic AUD_DACLRCK, AUD_ADCLRCK, AUD_ADCDAT,AUD_BCLK,
						output logic [15:0]  LDATA, RDATA,
						output logic INIT,
				 		output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
adc_sm SM(.*, .clock(Clk), .Reset(reset));

audio_interface interfaceInst( .clk(Clk), .Reset(reset), .LDATA, .RDATA, .INIT, .AUD_DACLRCK, .AUD_ADCLRCK, .AUD_ADCDAT, .ADCDATA, .INIT_FINISH, .adc_full, .data_over, .AUD_MCLK, .AUD_DACDAT, .I2C_SDAT, .I2C_SCLK, .AUD_BCLK );

HexDriver inst0(.In0(ADCDATA[3:0]), .Out0(Hex0));
HexDriver inst1(.In0(ADCDATA[7:4]), .Out0(Hex1));
HexDriver inst2(.In0(ADCDATA[11:8]), .Out0(Hex2));
HexDriver inst3(.In0(ADCDATA[15:12]), .Out0(Hex3));
HexDriver inst4(.In0(ADCDATA[19:16]), .Out0(Hex4));
HexDriver inst5(.In0(ADCDATA[23:20]), .Out0(Hex5));
HexDriver inst6(.In0(ADCDATA[27:24]), .Out0(Hex6));
HexDriver inst7(.In0(ADCDATA[31:28]), .Out0(Hex7));



endmodule
