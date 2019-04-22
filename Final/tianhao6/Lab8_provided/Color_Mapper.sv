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
module  color_mapper ( input              is_avatar, VGA_BLANK_EX, Clk,           // Whether current pixel belongs to ball                                       //   or background (computed in ball.sv)
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       input        [9:0] sky, ground,
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    // Output colors to VGA
		logic [7:0] Red, Blue, Green;
		paletteToRGB paletteInst (.colorIdx(outData), .R(Red), .G(Green), .B(Blue));
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
		logic [19:0] testPt, testPtIn;
		reg [3:0] buffer [307200]; //memory <= '{default:'1}
		logic [3:0] outData;


    // 2 always
		always_comb begin
			testPtIn = testPt + 20'd1;
		end
		always_ff @ (posedge Clk) begin
			if(~VGA_BLANK_EX) begin
				testPt <= testPtIn;
			end
			else begin
				testPt <= 20'd0;
			end
		end

		logic [3:0] inData;
		assign inData = 4'd3;

		logic [19:0] drawPtVGA;
		assign drawPtVGA = {10'd0, DrawX} + ({10'd0, DrawY} * 20'd800);
		always_ff @ (posedge Clk) begin
				if (testPt <= 20'd307199) begin
					// if (WE)
					buffer[testPt] <= inData; // input write to  buffer
				end
				if (drawPtVGA <= 20'd307199) begin
					outData <= buffer[drawPtVGA];
				end

		end

		// always_comb
    // begin
    //     if (is_avatar == 1'b1)
    //     begin
    //         // White ball
    //         inData = 4'd1;
    //     end
    //     else if (DrawY <= sky)
    //       begin
    //         inData = 4'd2;
    //       end
    //     else if (DrawY >= ground)
    //       begin
    //         // 255, 204, 102
    //         inData = 4'd3;
    //         end
    //     else
    //     begin
    //         inData = 4'd4;
    //     end
		// end


endmodule
