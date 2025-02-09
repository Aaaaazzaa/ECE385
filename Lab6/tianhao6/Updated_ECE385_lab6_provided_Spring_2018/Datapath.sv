module datapath(input logic Reset, Clk, Continue, Run,
					 input logic LD_MDR, LD_MAR, LD_CC, LD_BEN, LD_IR, ADDR1MUX, LD_PC, DR, LD.REG, SR1,
					 input logic GateMARMUX, GatePC, GateALU, GateMDR,
					 input logic [1:0] PCMUX, ADDR2MUX, ALUK,
					 input logic [2:0] SR2,
					 input logic [15:0] Data_to_CPU,
					 output logic [15:0] MDR,
					 output logic [11:0] LED,
					 output logic [15:0] MAR, IR
					 );
					 logic [15:0] BUS, MIOMUX_OUT,PC,PCMUX_OUT;
					unique case({GatePC, GateMDR, GateALU, GateMARMUX})
						1000:
							BUS=PC;
						0100:
							BUS=MDR;
						0010:
							BUS=ALU;
						0001:
							BUS=MARMUX;
						default:
							BUS=16'bXXXXXXXXXXXXXXXX;
					endcase
					unique case(MIO_EN)
						1:
							MIOMUX_OUT=BUS;
						0:
							MIOMUX_OUT=Data_to_CPU;
						default:
							MIOMUX_OUT=Data_to_CPU;
					endcase
					bit16reg MDR(.Clk, .Reset, .LoadEn(LD_MDR), 	.inbits(MIOMUX_OUT), .outbits(MDR));
					bit16reg IR(.Clk, .Reset, 	.LoadEn(LD_IR), 	.inbits(BUS), .outbits());
					bit16reg PC(.Clk,	.Reset,	.LoadEn(LD_PC)，	.inbits(PCMUX_OUT),	.outbits(PC));
					unique case(PCMUX)
						00:
							PCMUX_OUT=
						01:
							PCMUX_OUT=
						10:
							PCMUX_OUT=
						11:
							PCMUX_OUT=
						default:
							PCMUX_OUT=
					endcase
					