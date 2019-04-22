// module paletteToRGB(  input logic [3:0] colorIdx, backcolorIdx,
//                       input logic isBackground,
//                       output logic [7:0] R, G, B
//                       );
//   assign Idx = ((4'd0 == colorIdx) && (isBackground==0)) ? backcolorIdx : colorIdx;
  module paletteToRGB(  input logic [3:0] colorIdx,
                        output logic [7:0] R, G, B
                        );
  // enter your 16 color palette
  always_comb begin
    unique case (colorIdx)
      4'd0: begin
        //0x9C2E99 light purple
          R = 8'hFF;
          G = 8'h00;
          B = 8'hFF;
        end
      4'd1: begin
//		  0xFF00FF, 
//		  0x9C2E99, 
//		  0x5E2464, 
//		  0xB4C3EB, 
//		  0xF2C571, 
//		  0xA9814A, 
//		  0xDAEFDE,
//		  0x294656, 
//		  0xA9BDC5, 
		  
		  
          R = 8'h9C;
          G = 8'h2E;
          B = 8'h99;
        end
      4'd2: begin
        //0xB4C3EB sky blue
          R = 8'h5E;
          G = 8'h24;
          B = 8'h64;
        end
      4'd3: begin
        //0xF2C571 sand yellow
          R = 8'hB4;
          G = 8'hC3;
          B = 8'hEB;
        end
      4'd4: begin
          R = 8'hF2;
          G = 8'hE5;
          B = 8'h71;
        end
      4'd5: begin
          R = 8'hA9;
          G = 8'h81;
          B = 8'h4A;
        end
      4'd6: begin
          R = 8'hDA;
          G = 8'hEF;
          B = 8'hDE;
        end
      4'd7: begin
          R = 8'h29;
          G = 8'h46;
          B = 8'h56;
        end
      4'd8: begin
          R = 8'hA9;
          G = 8'hBD;
          B = 8'hC5;
        end
      4'd9: begin
          R = 8'h00;
          G = 8'h00;
          B = 8'h03;
        end
      4'd10: begin
          R = 8'h00;
          G = 8'h00;
          B = 8'h04;
        end
      4'd11: begin
          R = 8'h00;
          G = 8'h00;
          B = 8'h05;
        end
      4'd12: begin
          R = 8'h00;
          G = 8'h00;
          B = 8'h06;
        end
      4'd13: begin
          R = 8'h00;
          G = 8'h00;
          B = 8'h07;
        end
      4'd14: begin
          R = 8'h00;
          G = 8'h00;
          B = 8'h08;
        end
      4'd15: begin
          R = 8'h00;
          G = 8'h00;
          B = 8'h09;
        end
    endcase
  end

endmodule
