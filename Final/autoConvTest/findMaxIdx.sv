module findMaxIdx(input logic signed [71:0] fout [480],
                  input logic shouldFind,
                  input logic Clk,
                  output logic [13:0] pitch);


    reg signed [71:0] maxVal;
    reg [9:0] maxIdx;
    reg [9:0] cnt;

    always_ff @ (posedge Clk) begin
      if (~shouldFind) begin
        maxVal = -72'h300000000000000000;
        maxIdx = 10'd0;
        cnt = 10'd47;
      end
      else if (cnt <= 10'd141) begin
        if(maxVal < fout[cnt]) begin
          maxVal <= fout[cnt];
          maxIdx <= cnt;
        end
        cnt <= cnt + 10'd1;
      end
    end
    // assign pitch = (cnt >= 10'd141) ? (14'd12000 / {4'd0, maxIdx}) : 14'd0;
    assign pitch = (cnt > 10'd141) ? (14'd12000 / {4'd0, maxIdx}) : 14'd0;

endmodule
