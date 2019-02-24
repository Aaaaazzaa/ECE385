module AddrGenerator(	input logic [1:0] ADDR2MUX,
								input logic ADDR1MUX,
								input logic [15:0] IR, PC, SR1_Out,
								output logic [15:0] Addr_Out
						  );
							logic [15:0] SEXTIR10, SEXTIR8, SEXTIR5;
							logic [15:0] To_AdderL, To_AdderR;
							SEXT  #(10) sext10_inst (.In(IR), .Out(SEXTIR10));
							SEXT  #(8)  sext8_inst  (.In(IR), .Out(SEXTIR8));
							SEXT  #(5)  sext5_inst  (.In(IR), .Out(SEXTIR5));
							// implied ADDR2MUX MUX
							always_comb begin
								unique case (ADDR2MUX)
									2'b00:
										To_AdderL = 16'h0000;
									2'b01:
										To_AdderL = SEXTIR5;
									2'b10:
										To_AdderL = SEXTIR8;
									2'b11:
										To_AdderL = SEXTIR10;
									endcase
							end
							// implied ADDR1MUX MUX
							always_comb begin
								unique case (ADDR1MUX)
									1'b0:
										To_AdderR = PC;
									1'b1:
										To_AdderR = SR1_Out;
									endcase
							end
							assign Addr_Out = To_AdderR + To_AdderL;


endmodule
