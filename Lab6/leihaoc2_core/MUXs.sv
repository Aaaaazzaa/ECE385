module DRMUX( input logic [2:0] IR11_9,
              input logic DR,
              output logic [2:0] DRMUX_Out
              );
              always_comb begin
                unique case (DR)
                  1'b0:
                    DRMUX_Out = IR11_9;
                  1'b1:
                    DRMUX_Out = 3'b111;
                  default:
                    DRMUX_Out = 3'b000;
                endcase
              end
endmodule
