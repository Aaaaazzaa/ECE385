module operation(	input logic Add, Sub,
						input logic [7:0]A, S,
						
						output logic [7:0]NewA,
						output logic NewX);
	// perform ADD(SUB) 
	logic [7:0] S_;
	logic Cin_, dev11, dev1;
	
	always_comb 
	// force comb with all modules inside as pure comb (aasume always ready)
	begin
		if(Sub)
		begin
			// take the 2's complement of S
			S_ = ~ S;
			Cin_ = 1'b1; 
		end
		else begin
			S_ = S;
			Cin_ = 1'b0;
		end
	end
	// complement S conditionally	
	// ADDER8 complement (.A(tmp), .B(S_), .cin(1'b0), .S(S2), .cout(dev1));
	// omit overflow handling
	// add S_(se) to A
	adder_9bit FA9 (.S( {S_[7],S_} ), .Ai( {A[7],A} ), .Cin(Cin_), .Ao(NewA), .X(NewX), .C(dev11));
	
//	always
//	// was always_comb but contain non-comb logic
//		begin 
//			M = B[0];
//			interm = {NewX, NewA, B} >>>1;
//			if(Clr_Ld) 
//				MUXB = S;
//			else 
//				MUXA = interm[15:8];
//				MUXB = interm[7:0];
//	end

	
endmodule 