//module testbench2();
//timeunit 10ns; 
//
//timeprecision 1ns;
//logic Clk = 0;
//logic reset;
//logic [31:0] ADCDATA;
//logic [1:0] fstateIN;
//logic INIT_FINISH, adc_full, INIT, INITIN;
//audiotest inst(.*, .clock(Clk));
//
//always_comb begin : INTERNAL_MONITORING
//
//INITIN = inst.SM.INIT;
//fstateIN = inst.SM.fstate;
//end
//always begin : CLOCK_GENERATION
//#1 Clk = ~Clk;
//end
//
//initial begin: CLOCK_INITIALIZATION
//    Clk = 0;
//end
//
//initial begin: TEST_VECTORS
//#2 reset = 1'b1;
//#2 reset = 1'b0;
//
//#2 INIT_FINISH = 1'b1;
//
//#10 adc_full = 1'b1;
//
//#10 adc_full = 1'b0;
//
//#10 adc_full = 1'b1;
//
//#10 adc_full = 1'b0;
//
//#10 adc_full = 1'b1;
//
//#10 adc_full = 1'b0;
//end
//endmodule
