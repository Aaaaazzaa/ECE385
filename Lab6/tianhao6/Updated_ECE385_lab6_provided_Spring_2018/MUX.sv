module MUX41(input logic [15:0]	IN0,	IN1,	IN2,	IN3,
				 input logic [1:0]	selectbits
				 output logic [15:0]	OUT);
				 always_comb
					begin
					if(selectbits==00)
						begin
							assign OUT=IN0;
						end
					else if(selectbits==01)
						begin
							assign OUT=IN1;
						end
					else if(selectbits==10)
						begin
							assign OUT=IN2;
						end
					else if(selectbits==11)
						begin
							assign OUT=IN3;
						end
					else
						begin
							assign OUT=16'bXXXXXXXXXXXXXXXX;
						end
					end
endmodule


module MUX21(input logic [15:0]	IN0,	IN1,
				 input logic selectbit.
				 output logic [15:0]	OUT);
				 always_comb
					begin
					if(selectbits==0)
						begin
							assign OUT=IN0;
						end
					else if(selectbits==1)
						begin
							assign OUT=IN1;
						end
					end
endmodule

