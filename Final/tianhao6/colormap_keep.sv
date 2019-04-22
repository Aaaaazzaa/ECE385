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
module  color_mapper ( input 					Clk,
							  input        [9:0] sprtiePosX [2],            // Whether current pixel belongs to ball                                       //   or background (computed in ball.sv)
                       input        [9:0] sprtiePosY [2],
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       input        [9:0] sky, ground,
                       input logic [9:0] Ball_X_Pos,
                       input logic [9:0] Ball_Y_Pos,
                       input        VGA_BLANK_EX, Reset_h,
                       output logic [7:0] VGA_R, VGA_G, VGA_B, // VGA RGB output
                       output logic CE, UB, LB, OE, WE,
                       output logic [15:0] DataOutSram,
                       output logic [19:0] ADDR
                       // deleted input is_avatar
                     );
    // tmp
    logic [19:0] drawPtSprite;
    logic [19:0] drawPtFrame, drawPtVGA;
    logic ClearFrame, BufferWE;
    logic [3:0] outData;
    sramIOHandler sramInst(.*);
    drawPoint Spite2FrameMapper(.*);
    frameBuffer bufferInst(.*, .WE(BufferWE), .drawData(DataOutSram[11:8]));


    // OCM memory
	  reg [3:0] backOCM [8192];
    initial begin
        $readmemh("sky128_64.txt", backOCM);

    end

    parameter [9:0] backXDim = 20'd128; // 2^7
    parameter [9:0] backYDim = 20'd64; // 2^6

    logic [7:0] Red, Green, Blue;
    logic [7:0] R, G, B, avatarR, avatarG, avatarB;
    logic [6:0] backXPos;
    logic [5:0] backYPos;
	  logic [12:0] OCMIdx;
	  assign OCMIdx = {backYPos, backXPos}; // backYPos << 7 + backXPos
    assign backXPos = DrawX[6:0]; // drawX % backXDim;
    assign backYPos =  DrawY[5:0]; // drawY % backYDim;

    // Assign color based on is_ball signal
    assign drawPtVGA = {10'd0, DrawX} + {10'd0, DrawY} * 10'd640;
    paletteToRGB avatarcolor (.colorIdx(outData), .R(avatarR), .G(avatarG), .B(avatarB));
    always_comb begin
      if(outData == 4'd0) begin
        Red = 8'd255;
        Green = 8'd204;
        Blue = 8'd102;
      end
      else begin
        Red = avatarR;
        Green = avatarG;
        Blue = avatarB;
      end
    end
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
endmodule
