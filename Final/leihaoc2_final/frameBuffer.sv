module frameBuffer (  input logic Clk, Reset_h, WE,
                      input logic [19:0] drawPtFrame, // write pt idx
                      input logic [19:0] drawPtVGA,
                      input logic [3:0] drawData,
                      output logic [3:0] outData //  pixel is drawn one by one match palette to color in realtime
                    );

reg [3:0] buffer [307200]; //memory <= '{default:'1}
always_ff @ (posedge Clk) begin
//  if(Reset_h) begin
//	 buffer <= '{default:'1};
//     for (int i = 0; i < 307200; i++ ) begin
//       buffer[i] <= 4'h0;
//   end
//   end
// never reset
    outData <= buffer[drawPtVGA];
    // synchronized read
    buffer[drawPtFrame] <= drawData; // input write to  buffer
end
endmodule
