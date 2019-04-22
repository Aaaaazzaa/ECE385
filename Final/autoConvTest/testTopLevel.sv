module testTopLevel( input logic Clk, Reset_h, VGA_CLK,
							output logic VGA_BLANK_EX,
							output logic [19:0] testPt);


logic VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N;
logic [9:0] DrawX, DrawY;
logic [19:0] drawPtVGA;
//logic CE, UB, LB, OE, WE;
//logic [15:0] DataOutSram; 
assign drawPtVGA = {10'd0, DrawX} + ({10'd0, DrawY} * 20'd640);
VGA_controller VGAInst (.*, .Reset(Reset_h));
always_ff @ (posedge Clk) begin
			if(VGA_BLANK_EX == 1'd1) begin
				testPt <= 20'd0;
			end
			else begin
				testPt <= testPt + 20'd1;
			end
end

endmodule
