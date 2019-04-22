module sramIOHandler( input logic Clk,
                      input logic [3:0] spriteNum,
                      input logic [9:0] frameXOffset, frameYOffset, drawX, drawY,
                      input logic [1:0] layer,
                      input logic isNpc, isAvatar,
                      input logic VGA_VS, // read to spritebuffer only when not at notch
                      output logic [19:0] ADDR, 
					            output logic CE, UB, LB, OE, WE, //  pin of sram
                      // output logic [4499:0] spriteLUT, // 67 * 67 pixel sprite 
                      output logic readDone, // ? 
                      output logic [3:0] backcolorIdx, 
                      output logic [3:0] colorIdx
                      output logic isBackground
  ); 
  
  
  
  endmodule 