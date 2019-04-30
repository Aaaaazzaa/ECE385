module drawPoint (  input logic [19:0] drawPtSprite,
                    input logic [9:0] Ball_X_Pos, Ball_Y_Pos,
                    output logic [19:0] drawPtFrame

                    );
parameter numColSprite = 20'd35;
parameter [19:0] spriteDim0 = 20'd17;
parameter [19:0] spriteDim1 = 20'd12;

logic [19:0] ptSpriteDim0, ptSpriteDim1, tmp0, tmp1;

assign ptSpriteDim0 = drawPtSprite / numColSprite;
assign ptSpriteDim1 = drawPtSprite - ptSpriteDim0 * numColSprite; // k % n

assign tmp1 = ptSpriteDim1 + {10'd0, Ball_X_Pos} - spriteDim0;
assign tmp0 = ptSpriteDim0 + {10'd0, Ball_Y_Pos} - spriteDim1;

assign drawPtFrame =  tmp1 + tmp0 * 20'd640;

endmodule
