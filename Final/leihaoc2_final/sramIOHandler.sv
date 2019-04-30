// module sramIOHandler( input logic Clk,
//                       input logic [3:0] spriteNum,
//                       input logic [9:0] frameXOffset, frameYOffset, drawX, drawY,
//                       input logic [1:0] layer,
//                       input logic isNpc, isAvatar,
//                       input logic VGA_VS, // read to spritebuffer only when not at notch
//                       output logic [19:0] ADDR,
// 					            output logic CE, UB, LB, OE, WE, //  pin of sram
//                       // output logic [4499:0] spriteLUT, // 67 * 67 pixel sprite
//                       output logic readDone, // ?
//                       output logic [3:0] backcolorIdx,
//                       output logic [3:0] colorIdx
//                       output logic isBackground
//   ); // contains sm, tristate buffer
 // state xcor, start ycor, xdim, ydim determoined by spriteNum,
module sramIOHandler( input logic Clk, VGA_BLANK_EX, Reset_h,
                     output logic CE, UB, LB, OE, WE,
                     //input logic [19:0]  EndAddr,  // change later
                     output logic [15:0] DataOutSram,
                     output logic [19:0] ADDR,
                     output logic [19:0] drawPtSprite,
                     output logic ClearFrame, BufferWE // active high
);
logic ReadDone, UpdateAddr;
logic [19:0] EndAddr;
assign drawPtSprite = ADDR - 20'd1;
always_ff @ (posedge Clk) begin
 if (Reset_h) begin
   ADDR <= 20'd0;
 end
 else if (UpdateAddr ) begin
   ADDR <= ADDR + 20'd1;
 end
end
// sm input pins
assign  ReadDone = (ADDR + 1'd1) >= EndAddr; // inclusive
assign EndAddr = 20'd874;
// sram input pins
assign CE = 1'b0;
assign WE = 1'b1;
assign OE = 1'b0;
assign LB = 1'b0;
assign UB = 1'b0;

SM1 sramcontrollerInst (.reset(Reset_h), .clock(Clk), .ReadDone, .Blank(VGA_BLANK_EX), .Clear(ClearFrame), .BufferWE, .UpdateAddr);
// blank is a VGA_VS like signal

endmodule
