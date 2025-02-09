module stateISB(  input [127:0] state,
                  input clk,
                  output [127:0] result);
InvSubBytes instISB16[15:0] (clk,
                            {state[127:120],
                            state[119:112],
                            state[111:104],
                            state[103:96],
                            state[95:88],
                            state[87:80],
                            state[79:72],
                            state[71:64],
                            state[63:56],
                            state[55:48],
                            state[47:40],
                            state[39:32], 
                            state[31:24],
                            state[23:16],
                            state[15:8],
                            state[7:0]},
                            {result[127:120],
                            result[119:112],
                            result[111:104],
                            result[103:96],
                            result[95:88],
                            result[87:80],
                            result[79:72],
                            result[71:64],
                            result[63:56],
                            result[55:48],
                            result[47:40],
                            result[39:32],
                            result[31:24],
                            result[23:16],
                            result[15:8],
                            result[7:0]});
endmodule
