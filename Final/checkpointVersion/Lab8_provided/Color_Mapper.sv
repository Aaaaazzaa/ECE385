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
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output

                     );
	 reg [3:0] backOCM [8192];
    initial begin
        $readmemh("sky128_64.txt", backOCM);
        $display("mem = %p",backOCM);
    end
    parameter [9:0] backXDim = 20'd128; // 2^7
    parameter [9:0] backYDim = 20'd64; // 2^6

    logic [7:0] Red, Green, Blue;
    logic [7:0] backR, backG, backB;
    logic [6:0] backXPos;
    logic [5:0] backYPos;
	 logic [12:0] OCMIdx;
	 assign OCMIdx = {backYPos, backXPos}; // backYPos << 7 + backXPos
    assign backXPos = DrawX[6:0]; // drawX % backXDim;
    assign backYPos =  DrawY[5:0]; // drawY % backYDim;

    paletteToRGB paletteInstL0 (.colorIdx( backOCM[OCMIdx] ), .R(backR), .G(backG), .B(backB));
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;

    // Assign color based on is_ball signal
    always_comb
    begin
        if (is_avatar == 1'b1)
        begin
            // White ball
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
        end
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
        else
        begin
            // Background with nice color gradient
            Red = backR;
            Green = backG;
            Blue = backB;
        end
    end

endmodule
