module autoConvolution(	input logic Clk,
								input logic [10:0] soundIn [15:0], // unpacked array: element = digitalized magnitude, idx = time 
								output logic [10:0] result [30:0] // unpacked array: element = fourier domain magnitude, idx = frequency
								);
//// proper blockization may have been applied
//// perform convolution with itself
//logic [10:0] energy, magnitude, plusmag, convolveresult, convolveinter, convolve;
//logic [10:0] interResult [15:0];
//parameter energyThre = 11'd0; 
//assign energy = 11'd0;
//always_comb begin 
////	for (int i = 0; i < 16; i++) begin
////		/* code */
////		magnitude = soundIn[i] * soundIn[i];
////		plusmag = energy + magnitude;
////		energy = plusmag;
////	end
//
//	if(energy > energyThre) begin
//		/* code */
//		 for (int i = 0; i < 31 ; i++) begin
//		 	/* code */
//		 	convolveresult = 11'd0;
//		 	for (int j = 0; j < i+1 ; j++) begin
//		 		/* code */
//		 		if(i > 15 + j) begin
//		 			/* code */
//		 			convolve = 11'd0;
//		 		end
//		 		else if(j > 15) begin
//		 			convolve = 11'd0;
//		 		end
//		 		else
//	 			begin 
//	 				convolve = soundIn[j]*soundIn[i-j];
//	 			end
////		 		convolveinter = convolveresult + convolve;
////		 		convolveresult = convolveinter;
//				
//		 	end
//		 	result[i] = convolveresult;
//		 end
//		end
//	else
//		begin
//			for (int i = 0; i < 31; i++) begin
//				/* code */
//				result[i] = 11'd0;
//			end
//		end
//end
logic reset, start, Convolve, counter;
logic [4:0] remaintime = 5'd31; 
logic [4:0] index;
logic [10:0] soundinv[15:0];
logic [10:0] interresult, multiple;
convolution convolve(.reset, .clock(Clk), .counter, .start, .Convolve);
always_ff @ (posedge Clk)
	begin
		if(Convolve)
			begin
				index = 5'd31 - remaintime;
				remaintime = remaintime - 5'd1;
				interresult = 11'd0;
				for(int i = 0; i < 16; i++) begin
					multiple = soundIn[i] * soundinv[i];
					interresult = interresult + multiple;
				end
				result[index] = interresult;
			end
	end
always_comb 
	begin
		if(remaintime)
			begin
				counter = 1'b1;
			end
		else
			counter = 1'b0;
	end

endmodule 