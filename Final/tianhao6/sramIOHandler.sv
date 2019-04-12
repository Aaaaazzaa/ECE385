module sramIOHandler( input logic [3:0] spriteNum,
                      input logic [9:0] xstart, ystart, xdim, ydim,
                      input logic VGA_VS, // read to spritebuffer only when not at notch
                      output logic [19:0] ADDR,
					            output logic CE, UB, LB, OE, WE,
                      output logic [4499:0] spriteData,
                      output logic readDone
  ); // contains sm, tristate buffer
  // state xcor, start ycor, xdim, ydim determoined by spriteNum,








endmodule
