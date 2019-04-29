
module DE2_Audio_Example (
	// Inputs
	CLOCK_50,
	CLOCK_27,
	KEY,

	AUD_ADCDAT,

	// Bidirectionals
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,

	I2C_SDAT,

	// Outputs
	AUD_XCK,
	AUD_DACDAT,

	I2C_SCLK,
	//EXP_SOUNDIN,
	SW,
	//SUMRESULT,
	HEX0, HEX1, HEX2, HEX3, HEX4, HEX4, HEX5, HEX6, HEX7,
	LEDG, LEDR
	//EXP_SOUNDIN
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input				CLOCK_50;
input				CLOCK_27;
input		[3:0]	KEY;
input		[3:0]	SW;

input				AUD_ADCDAT;


// Bidirectionals
inout				AUD_BCLK;
inout				AUD_ADCLRCK;
inout				AUD_DACLRCK;

inout				I2C_SDAT;

// Outputs
output				AUD_XCK;
output				AUD_DACDAT;

output				I2C_SCLK;
//output [31:0] EXP_SOUNDIN;
//output [25:0] SUMRESULT;
output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX4, HEX5, HEX6, HEX7;
output [8:0] LEDG;
output [17:0] LEDR;
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires
wire				audio_in_available;
wire		[31:0]	left_channel_audio_in;
wire		[31:0]	right_channel_audio_in;
wire				read_audio_in;

wire				audio_out_allowed;
wire		[31:0]	left_channel_audio_out;
wire		[31:0]	right_channel_audio_out;
wire 		[31:0]  absData;
wire				write_audio_out;
wire 						isVoice;
//wire 		[31:0] EXP_SOUNDIN;
//wire 		[25:0] SUMRESULT;
// Internal Registers

reg [18:0] delay_cnt, delay;
reg snd;
reg 		[25:0]  blockSum;
reg 		[25:0]  sumResult;
reg 		[8:0]	bclkCnt;
reg     [1:0]   Cnt4;
reg 	  			 	BCLK4;
reg 		[13:0] pitch;
reg 	signed [31:0] soundIn0 [480];
reg   signed [31:0] soundIn1 [480];
reg   signed [31:0] soundInEX [480];
reg 					bufferFlag;
// State Machine Registers
parameter unsigned [10:0] sampleNumber = 11'd480;
/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

always @(posedge CLOCK_50)
	if(delay_cnt == delay) begin
		delay_cnt <= 0;
		snd <= !snd;
	end else delay_cnt <= delay_cnt + 1;

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign delay = {SW[3:0], 15'd3000};

wire [31:0] sound = (SW == 0) ? 0 : snd ? 32'd10000000 : -32'd10000000;


assign read_audio_in			= audio_in_available & audio_out_allowed;

assign left_channel_audio_out	= left_channel_audio_in+sound;
assign right_channel_audio_out	= right_channel_audio_in+sound;
assign write_audio_out			= audio_in_available & audio_out_allowed;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

Audio_Controller Audio_Controller (
	// Inputs
	.CLOCK_50						(CLOCK_50),
	.reset						(~KEY[0]),

	.clear_audio_in_memory		(),
	.read_audio_in				(read_audio_in),

	.clear_audio_out_memory		(),
	.left_channel_audio_out		(left_channel_audio_out),
	.right_channel_audio_out	(right_channel_audio_out),
	.write_audio_out			(write_audio_out),

	.AUD_ADCDAT					(AUD_ADCDAT),

	// Bidirectionals
	.AUD_BCLK					(AUD_BCLK),
	.AUD_ADCLRCK				(AUD_ADCLRCK),
	.AUD_DACLRCK				(AUD_DACLRCK),


	// Outputs
	.audio_in_available			(audio_in_available),
	.left_channel_audio_in		(left_channel_audio_in),
	.right_channel_audio_in		(right_channel_audio_in),

	.audio_out_allowed			(audio_out_allowed),

	.AUD_XCK					(AUD_XCK),
	.AUD_DACDAT					(AUD_DACDAT),

);

avconf #(.USE_MIC_INPUT(1)) avc (
	.I2C_SCLK					(I2C_SCLK),
	.I2C_SDAT					(I2C_SDAT),
	.CLOCK_50					(CLOCK_50),
	.reset						(~KEY[0])
);

HexDriver inst0(.In0(sumResult[3:0]), .Out0(HEX0));
HexDriver inst1(.In0(sumResult[7:4]), .Out0(HEX1));
HexDriver inst2(.In0(sumResult[11:8]), .Out0(HEX2));
HexDriver inst3(.In0(sumResult[15:12]), .Out0(HEX3));
HexDriver inst4(.In0(sumResult[19:16]), .Out0(HEX4));
HexDriver inst5(.In0(pitch[3:0]), .Out0(HEX5));
HexDriver inst6(.In0(pitch[7:4]), .Out0(HEX6));
HexDriver inst7(.In0(pitch[11:8]), .Out0(HEX7));

// abs(left_channel_audio_in)
always_comb begin
	if (left_channel_audio_in[31]) begin
		absData = ~(left_channel_audio_in) + 1'd1;
	end
	else
		absData = left_channel_audio_in;
end
// 40ms frame sum, 1920 bclk cyc
// A * 2 ^ 16
// Sum += A
// sum = 1920 * 2^ 15, 26 bits

// BCLK4 12kHz clock generator
always_ff @ (posedge AUD_BCLK) begin
	if (Cnt4 == 2'd3 || ~KEY[0]) begin
		Cnt4 <= 2'd0;
	end
	else begin
		Cnt4 <= Cnt4 + 2'd1;
	end
end

always_ff @ (posedge AUD_BCLK ) begin
	if (~KEY[0]) begin
		BCLK4 <= 1'd0;
	end
	else if (Cnt4 == 2'd3) begin
		BCLK4 <= ~BCLK4;
	end
end
// bufferFlag
always_ff @ (posedge BCLK4) begin
	if (~KEY[0])
		bufferFlag <= 1'b0;
	else if (~inBlock) begin
		bufferFlag <= ~bufferFlag;
	end
end

// current sample index
always_ff @ (posedge BCLK4) begin
	if (bclkCnt >= sampleNumber - 1) begin
		bclkCnt = 9'd0;
	end
	else begin
		bclkCnt += 9'd1;
	end
end

// blockSum summation
always_ff @ (posedge BCLK4) begin
	if (bclkCnt == sampleNumber - 1 ) begin
		sumResult = blockSum;
		blockSum = 26'd0;
	end
	else begin
		// take summation by default, absData come from left_channel_audio_in directly
		blockSum <= blockSum + {10'd0, absData[31:16]};
		// store into active buffer
		if (bufferFlag) begin
			soundIn1[bclkCnt] <= left_channel_audio_in;
		end
		else begin
			soundIn0[bclkCnt] <= left_channel_audio_in;
		end
	end
end




assign isVoice = (sumResult >= 26'd20000) ? 1'd1 : 1'd0;
assign LEDG[8] = isVoice;
assign inBlock = ~(bclkCnt == 9'd479);
//assign EXP_SOUNDIN = left_channel_audio_in;
//assign SUMRESULT = sumResult;
assign soundInEX = bufferFlag ? soundIn0 : soundIn1; // get the OTHER buffer porcessed
autoConvolution dspInst(.BCLK4, .Clk(CLOCK_50), .Reset_h(~KEY[0]), .inBlock, .soundIn(soundInEX), .pitch, .isVoice);
always_comb begin
	if (pitch > 14'd255 || pitch < 14'd85)
		LEDR[17] = 1'b1;
	else
		LEDR[17] = 1'b0;
	LEDR[0] = (pitch >= 14'd85);
	LEDR[1] = (pitch >= 14'd95);
	LEDR[2] = (pitch >= 14'd105);
	LEDR[3] = (pitch >= 14'd115);
	LEDR[4] = (pitch >= 14'd125);
	LEDR[5] = (pitch >= 14'd135);
	LEDR[6] = (pitch >= 14'd145);
	LEDR[7] = (pitch >= 14'd155);

	LEDR[8] = (pitch >= 14'd165);
	LEDR[9] = (pitch >= 14'd175);
	LEDR[10] = (pitch >= 14'd185);
	LEDR[11] = (pitch >= 14'd195);
	LEDR[12] = (pitch >= 14'd205);
	LEDR[13] = (pitch >= 14'd215);
	LEDR[14] = (pitch >= 14'd225);
	LEDR[15] = (pitch >= 14'd235);
	LEDR[16] = (pitch >= 14'd245);
end
endmodule
