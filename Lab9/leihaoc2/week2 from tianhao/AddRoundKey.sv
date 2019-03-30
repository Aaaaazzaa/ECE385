module AddRoundKey( input [127:0] roundkey,
                    input [127:0] state,
                    output [127:0] result);
assign result = roundkey ^ state; 
endmodule
