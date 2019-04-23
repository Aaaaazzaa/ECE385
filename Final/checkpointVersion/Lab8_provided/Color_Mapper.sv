//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input              is_avatar,            // Whether current pixel belongs to ball                                       //   or background (computed in ball.sv)
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       input        [9:0] sky, ground,
                       input        xDirection, xFlag,
                       input        [9:0] Ball_X_Pos, Ball_Y_Pos,
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output

                     );
	 reg [3:0] backOCM [11520];
   reg [3:0] Char0 [256];
   reg [3:0] Char1 [256];
   reg [3:0] Char2 [256];
    initial begin
        $readmemh("back128_90.txt", backOCM);
        $readmemh("Char0.txt", Char0);
        $readmemh("Char1.txt", Char1);
        $readmemh("Char2.txt", Char2);
    end
    parameter [9:0] backXDim = 20'd128; // 2^7
    parameter [9:0] backYDim = 20'd90; // 2^6

    logic [7:0] Red, Green, Blue;
    logic [7:0] backR, backG, backB;
    logic [6:0] backXPos;
    logic [6:0] backYPos;
	 logic [13:0] OCMIdx;
   logic [8:0] avatarIdx;
   //
   logic [7:0] A0R, A0B, A0G;
   logic [7:0] A1R, A1B, A1G;
   // tmp
   logic [9:0] inAvatarX;
   assign inAvatarX = DrawX - Ball_X_Pos ;
   logic [9:0] inAvatarY;
   assign inAvatarY = DrawY - Ball_Y_Pos ;

   assign avatarIdx = {inAvatarY[3:0], inAvatarX[3:0]};
	 assign OCMIdx = {backYPos[6:0], backXPos[6:0]}; // backYPos << 7 + backXPos
    assign backXPos = DrawX[6:0]; // drawX % backXDim;
    assign backYPos = DrawY[6:0]; // / backYDim * backYDim;  // drawY % backYDim;

    paletteToRGB paletteInstL0 (.colorIdx( backOCM[OCMIdx] ), .R(backR), .G(backG), .B(backB));
    paletteToRGB paletteInstA0 (.colorIdx( Char0[avatarIdx] ), .R(A0R), .G(A0G), .B(A0B));
    paletteToRGB paletteInstA1 (.colorIdx( Char1[avatarIdx] ), .R(A1R), .G(A1G), .B(A1B));
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;

    // Assign color based on is_ball signal
    always_comb
    begin
        if (is_avatar == 1'b1) begin
          if (xDirection && xFlag) begin
              // mag
              Red = 8'hff;
              Green = 8'h00;
              Blue = 8'hff;
          end
          else if (xDirection && (~xFlag)) begin
            // blue
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'hff;
          end
          else if ((~xDirection) && xFlag && (A1R != 8'd0 && A1G != 8'd0 && A1B != 8'd0)) begin
              // cyan
              Red = A1R;
              Green = A1G;
              Blue = A1B;
          end

          else if (~xDirection && ~xFlag && (A0R != 8'd0 && A0G != 8'd0 && A0B != 8'd0)) begin
            // red
            Red = A0R;
            Green = A0G;
            Blue = A0B;
          end
          else begin
			 // red
            Red = backR;
            Green = backG;
            Blue = backB;
			end
        end
        //
        else if (DrawY <= sky)
          begin
            Red = 8'd0;
            Green = 8'hff;
            Blue = 8'hff;
          end
        else if (DrawY >= ground)
          begin
            // 255, 204, 102
            Red = 8'd255;
            Green = 8'd204;
            Blue = 8'd102;
          end
        else begin
            // Background with nice color gradient
            Red = backR;
            Green = backG;
            Blue = backB;
        end
    end

endmodule
