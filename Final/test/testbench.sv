module testbench();
timeunit 10ns; // Half clock cycle at 50 MHz
   // This is the amount of time represented by #1
timeprecision 1ns;
logic Clk = 0;
logic [3:0] num1, num2, result;
logic [3:0] flag; 
logic inter;
test testinst(.*);

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end
initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end

always_comb begin
//flag = testinst.mem[1];
end

initial begin: TEST_VECTORS
#2 num1 = 2;
	num2 = 3;
#4 num1 = 11;
end
endmodule 