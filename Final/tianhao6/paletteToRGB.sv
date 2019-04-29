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
        //default color
          R = 8'hFF;
          G = 8'h00;
          B = 8'hFF;
        end
      4'd1: begin
		  // black
          R = 8'h00;
          G = 8'h10;
          B = 8'h00;
        end
      4'd2: begin
        // RED
          R = 8'hFF;
          G = 8'h46;
          B = 8'h29;
        end
      4'd3: begin
        // MILK
          R = 8'hE6;
          G = 8'hEF;
          B = 8'hDA;
        end
      4'd4: begin
        // LIGHT GREEN
          R = 8'h9C;
          G = 8'hFF;
          B = 8'h1F;
        end
      4'd5: begin
        // GREYISH GREEN
          R = 8'h6B;
          G = 8'hCA;
          B = 8'h67;
        end
      4'd6: begin
        // GREYISH BLUE
          R = 8'h8C;
          G = 8'hA5;
          B = 8'hBD;
        end
      4'd7: begin
        // DRAK BLUE
          R = 8'h08;
          G = 8'h25;
          B = 8'h77;
        end
      4'd8: begin
        // LIGHT GREY BLUE
          R = 8'hA9;
          G = 8'hBD;
          B = 8'hC5;
        end
      4'd9: begin
        // DRAK GREY BLUE
          R = 8'h3B;
          G = 8'h5D;
          B = 8'h66;
        end
      4'd10: begin
        // GOLD
          R = 8'hFB;
          G = 8'hC0;
          B = 8'h0C;
        end
      4'd11: begin
        // IRON
          R = 8'h6C;
          G = 8'h6D;
          B = 8'h71;
        end
      4'd12: begin
        //  0xCAB580
          R = 8'hCA;
          G = 8'hB5;
          B = 8'h80;
        end
      4'd13: begin
         //0x88674E
          R = 8'h88;
          G = 8'h67;
          B = 8'h4E;
        end
      4'd14: begin
        //0x634E52
          R = 8'h63;
          G = 8'h4E;
          B = 8'h52;
        end
      4'd15: begin
          R = 8'h00;
          G = 8'h00;
          B = 8'h09;
        end
    endcase
  end

endmodule
