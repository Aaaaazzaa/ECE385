module signedMod( input logic [9:0] num,
                  input logic [9:0] base,
                  output logic [9:0] result);
        logic [9:0] negNum;
        assign negNum = ~num + 10'd1;
        always_comb begin
          if(num[9]) begin
            result = ((negNum / base) + 10'd1) * base - negNum;
          end
          else begin
            result = num % base;
          end
        end
endmodule
