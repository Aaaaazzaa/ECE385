/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);
// IP core
// mealy state machine
logic Cycle, Update, Clear, Store, UpdateIMC, IMCDone;
logic unsigned [1:0] IMCcnt;
logic unsigned [3:0] round; // implied register
logic [1:0] Sel;
logic [31:0] outimc32, inimc;
logic [31:0] outIMC [4];
logic [127:0] outmux, outISB, outARK, outISR, roundkey;
logic [127:0] msg; // implied register
logic [1407:0] KeySchedule;
always_ff @ (posedge CLK) begin
	if(Clear | RESET) begin
		round <= 4'b0;
	end
	else if (Update) begin
		round <= round + 4'd1;
		IMCcnt <= 4'b0;
	end
	else if (UpdateIMC) begin
		outIMC[IMCcnt] = outimc32;
		IMCcnt = IMCcnt + 2'd1;
	end
end
assign Cycle = (round>=1) & (round<=9);
assign IMCDone = (IMCcnt == 3);
Lab9_mealy_sm sm(.clock(CLK), .reset(RESET), .SelL(Sel[0]), .SelH(Sel[1]), .*);

// KeyExpansion
KeyExpansion instKey (.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule);
// implied 11-1 MUX, Selcect roundkey
always_comb begin
	unique case(round)
	4'd10:
		roundkey = KeySchedule[1407 : 1280];
	4'd9:
		roundkey = KeySchedule[1279 : 1152];
	4'd8:
		roundkey = KeySchedule[1151 : 1024];
	4'd7:
		roundkey = KeySchedule[1023 : 896];
	4'd6:
		roundkey = KeySchedule[895  : 768];
	4'd5:
		roundkey = KeySchedule[767  : 640];
	4'd4:
		roundkey = KeySchedule[639  : 512];
	4'd3:
		roundkey = KeySchedule[511  : 384];
	4'd2:
		roundkey = KeySchedule[383  : 256];
	4'd1:
		roundkey = KeySchedule[255  : 128];
	4'd0:
		roundkey = KeySchedule[127  : 0];
	default:
		roundkey = 128'b1;
	endcase
end
// implied 4-1 MUX, AESLU
stateISB instISB (.clk(CLK), .state(msg), .result(outISB));
InvMixColumns instIMC(.in(inimc), .out(outimc32));
AddRoundKey instARK(.roundkey, .state(msg), .result(outARK));
InvShiftRows instISR(.data_in(msg), .data_out(outISR));

always_comb begin
	unique case(Sel)
	2'd0:
		outmux = outARK;
	2'd1:
		outmux = outISB;
	2'd2:
		outmux = outISR;
	2'd3:
		outmux = {outIMC[3], outIMC[2], outIMC[1], outIMC[0]};
	default:
		outmux = 128'b1;
	endcase
end
always_ff @ (posedge CLK) begin
	if (Clear | RESET)
		msg = AES_MSG_ENC;
	else if(Store)
		msg = outmux;
end

 // implied 4-1 MUX
always_comb begin
	unique case(IMCcnt)
		2'd0:
			inimc = msg[31:0];
		2'd1:
			inimc = msg[63:32];
		2'd2:
			inimc = msg[95:64];
		2'd3:
			inimc = msg[127:96];
	endcase
end
endmodule
