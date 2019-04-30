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
                       input        xDirection, xFlag, stopDirection, xFlagBoss,xFlagBullet,
                       input        [9:0] Ball_X_Pos, Ball_Y_Pos, progress,
                       input        [9:0] Boss_X_Pos, Boss_Y_Pos,
                       input        [9:0] Bullet_X_Pos, Bullet_Y_Pos,
                       input        is_boss, is_bullet, Bullet_X_Dir, alive, aliveBoss,
                       input        [1:0] health,
                       input        [3:0] digitH, digitM, digitL,
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
   reg [3:0] Boss0 [4096];
   reg [3:0] Boss1 [4096];
   reg [3:0] BulletR0[256];
   reg [3:0] BulletL0[256];
   reg [3:0] BulletR1[256];
   reg [3:0] BulletL1[256];
   reg [3:0] Heart0[1024];
   reg [3:0] n0 [1024];
   reg [3:0] n1 [1024];
   reg [3:0] n2 [1024];
   reg [3:0] n3 [1024];
   reg [3:0] n4 [1024];
   reg [3:0] n5 [1024];
   reg [3:0] n6 [1024];
   reg [3:0] n7 [1024];
   reg [3:0] n8 [1024];
   reg [3:0] n9 [1024];
   reg [3:0] points [4096];

    initial begin
        $readmemh("back128_128_4.txt", backOCM);
        $readmemh("Char0.txt", Char0);
        $readmemh("Char1.txt", Char1);
        $readmemh("Char2.txt", Char2);
        $readmemh("Char3.txt", Char3);
        $readmemh("Char4.txt", Char4);
        $readmemh("Char5.txt", Char5);
        $readmemh("Ground64_32.txt", ground64);
        $readmemh("Boss0.txt", Boss0);
        $readmemh("Boss1.txt", Boss1);
        $readmemh("Heart0.txt", Heart0);
        $readmemh("BulletR0.txt", BulletR0);
        $readmemh("BulletL0.txt", BulletL0);
        $readmemh("BulletR1.txt", BulletR1);
        $readmemh("BulletL1.txt", BulletL1);
        $readmemh("n0.txt", n0);
        $readmemh("n1.txt", n1);
        $readmemh("n2.txt", n2);
        $readmemh("n3.txt", n3);
        $readmemh("n4.txt", n4);
        $readmemh("n5.txt", n5);
        $readmemh("n6.txt", n6);
        $readmemh("n7.txt", n7);
        $readmemh("n8.txt", n8);
        $readmemh("n9.txt", n9);
        $readmemh("points.txt", points);

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
   logic [11:0] bossIdx;
   logic [7:0] bulletIdx;
   logic [9:0] Heart1Idx, Heart2Idx, Heart3Idx;
   logic [9:0] inNumIdx;
   logic [11:0] pointIdx;
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
   logic [7:0] B0R, B0B, B0G;
   logic [7:0] B1R, B1B, B1G;
   logic [7:0] ZR0R, ZR0G, ZR0B;
   logic [7:0] ZR1R, ZR1G, ZR1B;
   logic [7:0] ZL0R, ZL0G, ZL0B;
   logic [7:0] ZL1R, ZL1G, ZL1B;

   logic [7:0] H0R, H0G, H0B;
   logic [7:0] N0R, N0G, N0B;
   logic [7:0] N1R, N1G, N1B;
   logic [7:0] N2R, N2G, N2B;
   logic [7:0] N3R, N3G, N3B;
   logic [7:0] N4R, N4G, N4B;
   logic [7:0] N5R, N5G, N5B;
   logic [7:0] N6R, N6G, N6B;
   logic [7:0] N7R, N7G, N7B;
   logic [7:0] N8R, N8G, N8B;
   logic [7:0] N9R, N9G, N9B;

   logic [7:0] NR, NG, NB;
   logic [7:0] PTR, PTG, PTB;

   logic [12:0] DrawX_plus_progress;
   assign DrawX_plus_progress = {3'd0, DrawX} + {3'd0, progress};
   // tmp
   logic [9:0] inAvatarX;
   assign inAvatarX = DrawX - Ball_X_Pos ;
   logic [9:0] inAvatarY;
   assign inAvatarY = DrawY - Ball_Y_Pos ;

   logic [9:0] inBossX;
   assign inBossX = DrawX - Boss_X_Pos;
   logic [9:0] inBossY;
   assign inBossY = DrawY - Boss_Y_Pos;

   logic [9:0] inBulletX;
   assign inBulletX = DrawX - Bullet_X_Pos;
   logic [9:0] inBulletY;
   assign inBulletY = DrawY - Bullet_Y_Pos;

   logic isH;
   assign isH = (DrawX >= 10'd504 && DrawX < 10'd536) && (DrawY >=10'd48 && DrawY <= 10'd80);

   logic isM;
   assign isM = (DrawX >= 10'd546 && DrawX < 10'd578) && (DrawY >=10'd48 && DrawY <= 10'd80);

   logic isL;
   assign isL = (DrawX >= 10'd588 && DrawX < 10'd620) && (DrawY >=10'd48 && DrawY <= 10'd80);
	logic [9:0] inNumX;
   always_comb begin
     // implied 3-1 mux
     if (isH) begin
       inNumX = DrawX - 10'd504;
     end
     else if (isM) begin
       inNumX = DrawX - 10'd546;
     end
     else begin
       inNumX = DrawX - 10'd588;
     end
   end
   logic [9:0] inNumY;
   assign inNumY = DrawY - 10'd48;


   assign inNumIdx = {inNumY[4:0], inNumX[4:0]};
   logic [9:0] inHeart0X, inHeart1X, inHeart2X;
   logic [9:0] inHeart0Y, inHeart1Y, inHeart2Y;
   logic [9:0] pointY, pointX;

   logic isHeart1, isHeart2, isHeart3;
   assign inHeart0X = DrawX - 10'd32;
   assign inHeart0Y = DrawY - 10'd48;
   assign inHeart1X = DrawX - 10'd64;
   assign inHeart1Y = DrawY - 10'd48;
   assign inHeart2X = DrawX - 10'd96;
   assign inHeart2Y = DrawY - 10'd48;
   assign pointX = DrawX - 10'd356;
   assign pointY = DrawY - 10'd48;
   assign isHeart3 = (health == 2'd3);
   assign isHeart2 = (health >= 2'd2);
   assign isHeart1 = (health >= 2'd1);
   assign Heart1Idx = {inHeart0Y[4:0], inHeart0X[4:0]};
   assign pointIdx = {pointY[4:0], pointX[6:0]};
   // assign Heart2Idx = {inHeart1X[4:0], inHeart1Y[4:0]};
   // assign Heart3Idx = {inHeart2X[4:0], inHeart2Y[4:0]};

   assign avatarIdx = {inAvatarY[4:0], inAvatarX[4:0]};
   assign bossIdx = {inBossY[5:0], inBossX[5:0]};
   assign bulletIdx = {inBulletY[3:0], inBulletX[3:0]};

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

   paletteToRGB paletteInstB0 (.colorIdx( Boss0[bossIdx] ), .R(B0R), .G(B0G), .B(B0B));
   paletteToRGB paletteInstB1 (.colorIdx( Boss1[bossIdx] ), .R(B1R), .G(B1G), .B(B1B));

   paletteToRGB paletteInstZR0 (.colorIdx( BulletR0[bulletIdx] ), .R(ZR0R), .G(ZR0G), .B(ZR0B));
   paletteToRGB paletteInstZR1 (.colorIdx( BulletR1[bulletIdx] ), .R(ZR1R), .G(ZR1G), .B(ZR1B));
   paletteToRGB paletteInstZL0 (.colorIdx( BulletL0[bulletIdx] ), .R(ZL0R), .G(ZL0G), .B(ZL0B));
   paletteToRGB paletteInstZL1 (.colorIdx( BulletL1[bulletIdx] ), .R(ZL1R), .G(ZL1G), .B(ZL1B));
   paletteToRGB paletteInstH0 (.colorIdx( Heart0[Heart1Idx] ), .R(H0R), .G(H0G), .B(H0B));

   paletteToRGB paletteInstN1 (.colorIdx( n1[inNumIdx] ), .R(N1R), .G(N1G), .B(N1B));
   paletteToRGB paletteInstN2 (.colorIdx( n2[inNumIdx] ), .R(N2R), .G(N2G), .B(N2B));
   paletteToRGB paletteInstN3 (.colorIdx( n3[inNumIdx] ), .R(N3R), .G(N3G), .B(N3B));
   paletteToRGB paletteInstN4 (.colorIdx( n4[inNumIdx] ), .R(N4R), .G(N4G), .B(N4B));
   paletteToRGB paletteInstN5 (.colorIdx( n5[inNumIdx] ), .R(N5R), .G(N5G), .B(N5B));
   paletteToRGB paletteInstN6 (.colorIdx( n6[inNumIdx] ), .R(N6R), .G(N6G), .B(N6B));
   paletteToRGB paletteInstN7 (.colorIdx( n7[inNumIdx] ), .R(N7R), .G(N7G), .B(N7B));
   paletteToRGB paletteInstN8 (.colorIdx( n8[inNumIdx] ), .R(N8R), .G(N8G), .B(N8B));
   paletteToRGB paletteInstN9 (.colorIdx( n9[inNumIdx] ), .R(N9R), .G(N9G), .B(N9B));
   paletteToRGB paletteInstN0 (.colorIdx( n0[inNumIdx] ), .R(N0R), .G(N0G), .B(N0B));

   paletteToRGB paletteInstP0 (.colorIdx( points[pointIdx] ), .R(PTR), .G(PTG), .B(PTB));


   always_comb begin
     if (isH) begin
       unique case (digitH)
         4'd0: begin
          NR = N0R;
          NB = N0B;
          NG = N0G;
        end

        4'd1: begin
         NR = N1R;
         NB = N1B;
         NG = N1G;
       end
       4'd2: begin
        NR = N2R;
        NB = N2B;
        NG = N2G;
      end
      4'd3: begin
       NR = N3R;
       NB = N3B;
       NG = N3G;
     end
     4'd4: begin
      NR = N4R;
      NB = N4B;
      NG = N4G;
    end
    4'd5: begin
     NR = N5R;
     NB = N5B;
     NG = N5G;
   end
   4'd6: begin
    NR = N6R;
    NB = N6B;
    NG = N6G;
  end
  4'd7: begin
   NR = N7R;
   NB = N7B;
   NG = N7G;
 end
 4'd8: begin
  NR = N8R;
  NB = N8B;
  NG = N8G;
end
4'd9: begin
 NR = N9R;
 NB = N9B;
 NG = N9G;
end
default : begin
  NR = 8'd0;
  NB = 8'd0;
  NG = 8'd0;
end
endcase
     end
     else if (isM) begin
       unique case (digitM)
         4'd0: begin
          NR = N0R;
          NB = N0B;
          NG = N0G;
        end

        4'd1: begin
         NR = N1R;
         NB = N1B;
         NG = N1G;
       end
       4'd2: begin
        NR = N2R;
        NB = N2B;
        NG = N2G;
      end
      4'd3: begin
       NR = N3R;
       NB = N3B;
       NG = N3G;
     end
     4'd4: begin
      NR = N4R;
      NB = N4B;
      NG = N4G;
    end
    4'd5: begin
     NR = N5R;
     NB = N5B;
     NG = N5G;
   end
   4'd6: begin
    NR = N6R;
    NB = N6B;
    NG = N6G;
  end
  4'd7: begin
   NR = N7R;
   NB = N7B;
   NG = N7G;
 end
 4'd8: begin
  NR = N8R;
  NB = N8B;
  NG = N8G;
end
4'd9: begin
 NR = N9R;
 NB = N9B;
 NG = N9G;
end
default : begin
  NR = 8'd0;
  NB = 8'd0;
  NG = 8'd0;
end
endcase
     end
    else begin
      unique case (digitL)
        4'd0: begin
         NR = N0R;
         NB = N0B;
         NG = N0G;
       end

       4'd1: begin
        NR = N1R;
        NB = N1B;
        NG = N1G;
      end
      4'd2: begin
       NR = N2R;
       NB = N2B;
       NG = N2G;
     end
     4'd3: begin
      NR = N3R;
      NB = N3B;
      NG = N3G;
    end
    4'd4: begin
     NR = N4R;
     NB = N4B;
     NG = N4G;
   end
   4'd5: begin
    NR = N5R;
    NB = N5B;
    NG = N5G;
  end
  4'd6: begin
   NR = N6R;
   NB = N6B;
   NG = N6G;
 end
 4'd7: begin
  NR = N7R;
  NB = N7B;
  NG = N7G;
end
4'd8: begin
 NR = N8R;
 NB = N8B;
 NG = N8G;
end
4'd9: begin
NR = N9R;
NB = N9B;
NG = N9G;
end
default : begin
 NR = 8'd0;
 NB = 8'd0;
 NG = 8'd0;
end
endcase
    end
   end

   // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;

    // Assign color based on is_ball signal
    always_comb
    begin

          // draw boss
          if (xFlagBoss && (B0R != 8'd0 && B0G != 8'd0 && B0B != 8'd0) && is_boss && aliveBoss) begin
            Red = B0R;
            Green = B0G;
            Blue = B0B;
          end
          else if (~xFlagBoss && (B1R != 8'd0 && B1G != 8'd0 && B1B != 8'd0) && is_boss && aliveBoss) begin
            Red = B1R;
            Green = B1G;
            Blue = B1B;
          end
          else if (~xFlagBoss && (B1R != 8'd0 && B1G != 8'd0 && B1B != 8'd0) && is_boss && aliveBoss) begin
            Red = B1R;
            Green = B1G;
            Blue = B1B;
          end
          // draw bullet
          else if (xFlagBullet && is_bullet && Bullet_X_Dir && (ZR0R != 8'd0 && ZR0B != 8'd0 && ZR0G != 8'd0) && alive) begin
            Red = ZR0R;
            Green = ZR0G;
            Blue = ZR0B;
          end
          else if (~xFlagBullet && is_bullet && Bullet_X_Dir && (ZR1R != 8'd0 && ZR1B != 8'd0 && ZR1G != 8'd0) && alive) begin
            Red = ZR1R;
            Green = ZR1G;
            Blue = ZR1B;
          end
          else if (xFlagBullet && is_bullet && ~Bullet_X_Dir && (ZL0R != 8'd0 && ZL0B != 8'd0 && ZL0G != 8'd0) && alive) begin
            Red = ZL0R;
            Green = ZL0G;
            Blue = ZL0B;
          end
          else if (~xFlagBullet && is_bullet && ~Bullet_X_Dir && (ZL1R != 8'd0 && ZL1B != 8'd0 && ZL1G != 8'd0) && alive) begin
            Red = ZL1R;
            Green = ZL1G;
            Blue = ZL1B;
          end
			else if (is_avatar == 1'b1 && alive ) begin
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
        // draw boundary
        else if (DrawY <= sky)
          begin
            if(DrawX >= 10'd32 && DrawX <= 10'd64 && DrawY >=10'd48 && DrawY <= 10'd80 && isHeart1 && (H0R != 8'd0 && H0G != 8'd0 && H0B != 8'd0))
              begin
                Red = H0R;
                Green = H0G;
                Blue = H0B;
              end
            else if(DrawX >= 10'd64 && DrawX <= 10'd96 && DrawY >=10'd48 && DrawY <= 10'd80 && isHeart2 && (H0R != 8'd0 && H0G != 8'd0 && H0B != 8'd0))
              begin
                Red = H0R;
                Green = H0G;
                Blue = H0B;
              end
            else if(DrawX >= 10'd96 && DrawX <= 10'd128 && DrawY >=10'd48 && DrawY <= 10'd80 && isHeart3 && (H0R != 8'd0 && H0G != 8'd0 && H0B != 8'd0))
              begin
                Red = H0R;
                Green = H0G;
                Blue = H0B;
              end
            else if ((isH || isM || isL) && (NR != 8'hff && NB != 8'hff && NG != 8'h00)) begin
              Red = NR;
              Green = NG;
              Blue = NB;
            end
            else if(DrawX >= 10'd356 && DrawX <= 10'd484 && DrawY >=10'd48 && DrawY <= 10'd80 && (PTR != 8'hff && PTG != 8'd0 && PTB != 8'hff))
              begin
                Red = PTR;
                Green = PTG;
                Blue = PTB;
              end
            else
              begin
                Red = 8'd0;
                Green = 8'hff;
                Blue = 8'hff;
              end
          end
        else if (DrawY >= ground && DrawY <= ground + 10'd32 ) //&& (DrawX < holeCenter - holeSize || DrawX > holeCenter + holeSize)
          begin
            // 255, 204, 102
            Red = G0R;
            Green = G0G;
            Blue = G0B;
          end

        else begin
            // Background with nice color gradient
            Red = backR;//8'h00;
            Green = backG;//8'h00;
            Blue = backB;//8'h00;
        end
    end

endmodule
