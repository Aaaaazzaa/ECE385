module PCGenerator(input logic [15:0]	PC,
						 output logic [15:0]	newPC);
						 always_comb
							begin
							MUX41	PCMUX(.IN0,	IN1,	IN2,	IN3)