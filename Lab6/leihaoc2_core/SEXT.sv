module SEXT
  # (parameter baseWidth = 1)
  // number of bit needed
  (input logic [15:0] In,
   output logic [15:0] Out);
  assign Out[15: baseWidth+1] = {(15-baseWidth){In[baseWidth]}};
  assign Out[baseWidth:0] = In[baseWidth:0];

endmodule
