module RegFile (	input logic LD_REG, Clk, Reset,
                  input logic [15:0] Reg_In,
                  input logic [2:0] DRMUX_Out,
                  input logic [2:0] SR2, SR1MUX_Out,
                  output logic [15:0] SR1_Out, SR2_Out
                  );
  // ?? output: signle clk cycle, multi task
  // local registers unpacked array
  // enity: 16
  // local logic output of all reg_files, provided to choose from given SR1, SR2
  logic [15:0] Reg_Out [7:0];
  logic [7:0] LD_Which;

  always_comb begin
	if (LD_REG) begin
    case (DRMUX_Out)
          3'b000:
            LD_Which = 8'h01;
          3'b001:
            LD_Which = 8'h02;
          3'b010:
            LD_Which = 8'h04;
          3'b011:
            LD_Which = 8'h08;
          3'b100:
            LD_Which = 8'h10;
          3'b101:
            LD_Which = 8'h20;
          3'b110:
            LD_Which = 8'h40;
          3'b111:
            LD_Which = 8'h80;
          default:
            LD_Which = 8'h01;
        endcase
	end
	else begin
		LD_Which = 8'h0000;
	end
  end

  bit16Reg regiters [7:0] (.Clk, .Reset, .LdEn(LD_Which), .In(Reg_In), .Out(Reg_Out)); // unsure: Out array unroll

  always_comb begin
    case(SR1MUX_Out)
      3'b000:
        SR1_Out = Reg_Out[0];
      3'b001:
        SR1_Out = Reg_Out[1];
      3'b010:
        SR1_Out = Reg_Out[2];
      3'b011:
        SR1_Out = Reg_Out[3];
      3'b100:
        SR1_Out = Reg_Out[4];
      3'b101:
        SR1_Out = Reg_Out[5];
      3'b110:
        SR1_Out = Reg_Out[6];
      3'b111:
        SR1_Out = Reg_Out[7];
      default:
        SR1_Out = 16'hffff;
      endcase
  end

  always_comb begin
    case(SR2)
      3'b000:
        SR2_Out = Reg_Out[0];
      3'b001:
        SR2_Out = Reg_Out[1];
      3'b010:
        SR2_Out = Reg_Out[2];
      3'b011:
        SR2_Out = Reg_Out[3];
      3'b100:
        SR2_Out = Reg_Out[4];
      3'b101:
        SR2_Out = Reg_Out[5];
      3'b110:
        SR2_Out = Reg_Out[6];
      3'b111:
        SR2_Out = Reg_Out[7];
      default:
        SR2_Out = 16'hffff;
      endcase
  end

endmodule
