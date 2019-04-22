module testbench();
timeunit 10ns; // Half clock cycle at 50 MHz
   // This is the amount of time represented by #1
timeprecision 1ns;
logic Clk = 0;
logic vga_clk = 0;
//logic Reset_h; 
//logic [7:0] VGA_R,VGA_G,VGA_B,VGA_CLK,VGA_SYNC_N,VGA_BLANK_N,VGA_VS,VGA_HS;
//lab8 inst(.VGA_R, .VGA_G, .VGA_B, .VGA_CLK, .VGA_SYNC_N, .VGA_BLANK_N, .VGA_VS, .VGA_HS, .CLOCK_50(Clk));

logic Reset,VGA_HS,VGA_VS,VGA_BLANK_N,VGA_SYNC_N, VGA_BLANK_EX;
logic [9:0] DrawX,DrawY;
VGA_controller inst(.*, .VGA_CLK(vga_clk));



always_comb begin : INTERNAL_MONITORING

end
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end
always begin : CLOCK25_GENERATION
#2 vga_clk = ~vga_clk;
end
initial begin: CLOCK_INITIALIZATION
    Clk = 0;
	 vga_clk = 0; 
end

initial begin: TEST_VECTORS
#2 Reset = 1'b1;
#2 Reset = 1'b0;
end
endmodule
