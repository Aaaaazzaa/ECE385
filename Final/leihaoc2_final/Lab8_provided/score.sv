module score( input  [9:0] progress,
              input   [2:0] lifeBoss,
              output [3:0] digitH, digitM, digitL);

              logic [9:0]decScore;
              assign decScore = {1'b0, progress[9:1]} + {7'd0, 3'd7 - lifeBoss} * 10'd50;

              assign digitH = decScore / 10'd100;
              assign digitM = decScore / 10'd10 - {6'd0, digitH} * 10'd10;
              assign digitL = decScore - 10'd10 * {6'd0, digitM} - 10'd100 * {6'd0, digitH};

endmodule
