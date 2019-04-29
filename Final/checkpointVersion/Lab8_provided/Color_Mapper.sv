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
                       input        xDirection, xFlag, stopDirection,
                       input        [9:0] Ball_X_Pos, Ball_Y_Pos, progress,
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output

                     );

	 reg [3:0] backOCM [16384];
   reg [3:0] Char0 [1024];
   reg [3:0] Char1 [1024];
   reg [3:0] Char2 [1024];
	reg [3:0] Char3 [1024];
   reg [3:0] Char4 [1024];
   reg [3:0] Char5 [1024];
   reg [3:0] ground64 [2048];
    initial begin
        $readmemh("back128_128.txt", backOCM);
        $readmemh("Char0.txt", Char0);
        $readmemh("Char1.txt", Char1);
        $readmemh("Char2.txt", Char2);
        $readmemh("Char3.txt", Char3);
        $readmemh("Char4.txt", Char4);
        $readmemh("Char5.txt", Char5);
        $readmemh("Ground64_32.txt", ground64);
        // $readmemh("Char7.txt", Char7);
    end
    parameter [9:0] backXDim = 20'd128; // 2^7
    parameter [9:0] backYDim = 20'd128; // 2^6

    logic [7:0] Red, Green, Blue;
    logic [7:0] backR, backG, backB;
    logic [6:0] backXPos;
    logic [6:0] backYPos;
	 logic [10:0] groundYPos;
	 logic [13:0] OCMIdx;
   logic [10:0] groundIdx;
   logic [9:0] avatarIdx;
   //
   logic [9:0] holeCenter;
   logic [9:0] holeSize;
   assign holeCenter = 10'd160-progress;
   assign holeSize = 10'd32;
   //
   logic [7:0] A0R, A0B, A0G;
   logic [7:0] A1R, A1B, A1G;
   logic [7:0] A2R, A2B, A2G;
   logic [7:0] A3R, A3B, A3G;
   logic [7:0] A4R, A4B, A4G;
   logic [7:0] A5R, A5B, A5G;
   logic [7:0] G0R, G0B, G0G;

   logic [12:0] DrawX_plus_progress;
   assign DrawX_plus_progress = {3'd0, DrawX} + {3'd0, progress};
   // tmp
   logic [9:0] inAvatarX;
   assign inAvatarX = DrawX - Ball_X_Pos ;
   logic [9:0] inAvatarY;
   assign inAvatarY = DrawY - Ball_Y_Pos ;

   assign avatarIdx = {inAvatarY[4:0], inAvatarX[4:0]};
	 assign OCMIdx = {backYPos[6:0], backXPos[6:0]}; // backYPos << 7 + backXPos
    assign backXPos = DrawX[6:0]; // drawX % backXDim;
    assign backYPos = DrawY[6:0]; // / backYDim * backYDim;  // drawY % backYDim;
    assign groundIdx = {groundYPos[4:0],DrawX_plus_progress[5:0]};
	 assign groundYPos = DrawY[9:0] + 10'd16;
    paletteToRGB paletteInstL0 (.colorIdx( backOCM[OCMIdx] ), .R(backR), .G(backG), .B(backB));
    paletteToRGB paletteInstA0 (.colorIdx( Char0[avatarIdx] ), .R(A0R), .G(A0G), .B(A0B));
    paletteToRGB paletteInstA1 (.colorIdx( Char1[avatarIdx] ), .R(A1R), .G(A1G), .B(A1B));
    paletteToRGB paletteInstA2 (.colorIdx( Char2[avatarIdx] ), .R(A2R), .G(A2G), .B(A2B));
	 paletteToRGB paletteInstA3 (.colorIdx( Char3[avatarIdx] ), .R(A3R), .G(A3G), .B(A3B));
	 paletteToRGB paletteInstA4 (.colorIdx( Char4[avatarIdx] ), .R(A4R), .G(A4G), .B(A4B));
	 paletteToRGB paletteInstA5 (.colorIdx( Char5[avatarIdx] ), .R(A5R), .G(A5G), .B(A5B));
	 paletteToRGB paletteInstG0 (.colorIdx( ground64[groundIdx] ), .R(G0R), .G(G0G), .B(G0B));
	 // paletteToRGB paletteInstA7 (.colorIdx( Char7[avatarIdx] ), .R(A7R), .G(A7G), .B(A7B));
	 // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;

    // Assign color based on is_ball signal
    always_comb
    begin
        if (is_avatar == 1'b1) begin
          if (xDirection && xFlag && (A4R != 8'd0 && A4G != 8'd0 && A4B != 8'd0)) begin
              // mag
              Red = A4R;
              Green = A4G;
              Blue = A4B;
          end
          else if (xDirection && (~xFlag) && (A5R != 8'd0 && A5G != 8'd0 && A5B != 8'd0)) begin
            // blue
            Red = A5R;
            Green = A5G;
            Blue = A5B;
          end
          else if ((~xDirection) && xFlag && (A1R != 8'd0 && A1G != 8'd0 && A1B != 8'd0)) begin
              // cyan
              Red = A1R;
              Green = A1G;
              Blue = A1B;
          end

          else if (~xDirection && ~xFlag && (A2R != 8'd0 && A2G != 8'd0 && A2B != 8'd0)) begin
            // red
            Red = A2R;
            Green = A2G;
            Blue = A2B;
          end

          else if (stopDirection && (A3R != 8'd0 && A3G != 8'd0 && A3B != 8'd0)) begin
            Red = A3R;
            Green = A3G;
            Blue = A3B;
          end

          else if (~stopDirection  && (A0R != 8'd0 && A0G != 8'd0 && A0B != 8'd0)) begin
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
        else if (DrawY >= ground && DrawY <= ground + 10'd32 && (DrawX < holeCenter - holeSize || DrawX > holeCenter + holeSize))
          begin
            // 255, 204, 102
            Red = G0R;
            Green = G0G;
            Blue = G0B;
          end


        else begin
            // Background with nice color gradient
            Red = backR;
            Green = backG;
            Blue = backB;
        end
    end

endmodule
