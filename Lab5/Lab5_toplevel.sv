/* Module declaration.  Everything within the parentheses()
 * is a port between this module and the outside world */
 
module Lab5_toplevel
(
    input   logic           Clk,        // 50MHz clock is only used to get timing estimate data
    input   logic           Reset,      // From push-button 0.  Remember the button is active low (0 when pressed)
    input   logic           ClearA_LoadB,      // From push-button 1
    input   logic           Run,        // From push-button 3.
    input   logic[7:0]      S,        // From slider switches
    
    // all outputs are registered
    output  logic[6:0]      AhexL,      // Hex drivers display both inputs to the adder.
    output  logic[6:0]      AhexU,

    output  logic[6:0]      BhexL,
    output  logic[6:0]      BhexU,
	 output logic X,
	 output logic [15:0]		 result // go to LED

);

    /* Declare Internal Registers */
    logic[7:0]     Ain, A_result, dev8;  // use this as an input to your adder
    logic[7:0]     Bin, B_result, dev88;  // use this as an input to your adder
    
    /* Declare Internal Wires
     * Wheather an internal logic signal becomes a register or wire depends
     * on if it is written inside an always_ff or always_comb block respectivly */
	 logic[15:0]     result_comb;
    logic[6:0]      Ahex0_comb;
    logic[6:0]      Ahex1_comb;

    logic[6:0]      Bhex0_comb;
    logic[6:0]      Bhex1_comb;
	 logic  			  X_comb;
    
    /* Behavior of registers A, B, Sum, and CO */
assign result = result_comb;

 always_comb begin

				Bin = result_comb[7:0];
				Ain = result_comb[15:8];				

 end
    
    /* Decoders for HEX drivers and output registers
     * Note that the hex drivers are calculated one cycle after Sum so
     * that they have minimal interfere with timing (fmax) analysis.
     * The human eye can't see this one-cycle latency so it's OK. */
	  
//    always_ff @(posedge Clk) begin
//        
//        AhexL <= Ahex0_comb;
//        AhexU <= Ahex1_comb;
//
//        BhexL <= Bhex0_comb;
//        BhexU <= Bhex1_comb;
//
//        
//    end
    

	  
	 Multiplier mult_inst(.S(S), .Clk(Clk), .Reset(~Reset), .ClearA_LoadB(~ClearA_LoadB), .Exe(~Run), .Aval(dev8), .Bval(dev88), .X(X_comb), .result(result_comb));


    HexDriver Ahex0_inst
    (
        .In0(Ain[3:0]),   // This connects the 4 least significant bits of 
                        // register A to the input of a hex driver named Ahex0_inst
        .Out0(AhexU)
	 );
		  
    
    HexDriver Ahex1_inst
    (
        .In0(Ain[7:4]),
        .Out0(AhexL)
    );
    

    
    HexDriver Bhex0_inst
    (
        .In0(Bin[3:0]),
        .Out0(BhexU)
    );
    
    HexDriver Bhex1_inst
    (
        .In0(Bin[7:4]),
        .Out0(BhexL)
    );
    

    
endmodule
