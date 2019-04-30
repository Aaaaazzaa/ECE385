// //-------------------------------------------------------------------------
// //    Ball.sv                                                            --
// //    Viral Mehta                                                        --
// //    Spring 2005                                                        --
// //                                                                       --
// //    Modified by Stephen Kempf 03-01-2006                               --
// //                              03-12-2007                               --
// //    Translated by Joe Meng    07-07-2013                               --
// //    Modified by Po-Han Huang  12-08-2017                               --
// //    Spring 2018 Distribution                                           --
// //                                                                       --
// //    For use with ECE 385 Lab 8                                         --
// //    UIUC ECE Department                                                --
// //-------------------------------------------------------------------------
//
//
// module  avatar ( input         Clk,                // 50 MHz clock
//                              Reset,              // Active-high reset signal
//                              frame_clk,          // The clock indicating a new frame (~60Hz)
//                input [9:0]   DrawX, DrawY, sky, ground, gravity,       // Current pixel coordinates
//                input [31:0]   keycode,
//                output[9:0]   Ball_X_Pos, Ball_Y_Pos,
//                output logic  is_avatar,             // Whether current pixel belongs to ball or background
//                //output logic  is_bullet,
//                output logic  xFlag,
//                output logic xDirection,
//                output logic stopDirection,
//                output logic [9:0] progress,
//                output logic die
//                //output logic leftOn, rightOn, upOn, downOn, zOn, xOn
//               );
//
//     parameter [9:0] Ball_X_Center = 10'd320;  // Center position on the X axis
//     parameter [9:0] Ball_Y_Center = 10'd240;  // Center position on the Y axis
//     parameter [9:0] Ball_X_Min = 10'd0;       // Leftmost point on the X axis
//     parameter [9:0] Ball_X_Max = 10'd639;     // Rightmost point on the X axis
//     parameter [9:0] Ball_X_Step = 10'd4;      // Step size on the X axis
//     parameter [9:0] Ball_Y_Step = 10'd10;      // Step size on the Y axis
//     parameter [9:0] Ball_Size = 10'd32;        // Ball size
//
//     logic [9:0] Ball_X_Motion,  Ball_Y_Motion; // registers Q
//     logic [9:0] Ball_X_Pos_in,  Ball_X_Motion_in,   Ball_Y_Pos_in,   Ball_Y_Motion_in; // tmp same as D
//     logic [9:0] Ball_X_Progress, Ball_X_Progress_in;
//
//     logic [9:0] Bullet_X_Motion, Bullet_X_Motion_in;
//     logic [9:0] Bullet_Y_Motion, Bullet_Y_Motion_in;
//     logic [9:0] Bullet_X_Pos, Bullet_X_Pos_in;
//     logic [9:0] Bullet_Y_Pos, Bullet_Y_Pos_in;
//
//
//     logic[5:0] xCnt;
//     logic[9:0] holeCenter;
//     logic[9:0] holeSize;
//     assign holeSize = 10'd32;
//     assign holeCenter = 10'd160 - progress;
//     assign die = Ball_Y_Pos > 10'd480;
//
//
//     //////// Do not modify the always_ff blocks. ////////
//     // Detect rising edge of frame_clk
//
//     // logic [9:0] monster_X_Motion;
//     // logic [9:0] monster_Y_Motion;
//     // logic [9:0] monster_X_Pos;
//     // logic [9:0] monster_Y_Pos;
//     //
//     // assign upOn = (keycode[31:24] == 8'h52 | keycode[23:16] == 8'h52 | keycode[15: 8] == 8'h52 | keycode[ 7: 0] == 8'h52);
//     //
//     // assign downOn = (keycode[31:24] == 8'h51 | keycode[23:16] == 8'h51 | keycode[15: 8] == 8'h51 | keycode[ 7: 0] == 8'h51);
//     //
//     // assign leftOn = (keycode[31:24] == 8'h50 | keycode[23:16] == 8'h50 | keycode[15: 8] == 8'h50 | keycode[ 7: 0] == 8'h50);
//     //
//     // assign rightOn = (keycode[31:24] == 8'h4F | keycode[23:16] == 8'h4F | keycode[15: 8] == 8'h4F | keycode[ 7: 0] == 8'h4F);
//     //
//     //
//     // // jump
//     // assign zOn = (keycode[31:24] == 8'h1d | keycode[23:16] == 8'h1d | keycode[15: 8] == 8'h1d | keycode[ 7: 0] == 8'h1d);
//     // // fire
//     // assign xOn = (keycode[31:24] == 8'h1B | keycode[23:16] == 8'h1B | keycode[15: 8] == 8'h1B | keycode[ 7: 0] == 8'h1B);
//     assign upOn = keycode == 8'h1a;
//     assign leftOn = keycode == 8'h04;
//     assign rightOn = keycode == 8'h07;
//     assign downOn = keycode == 8'h16;
//
//
//     logic frame_clk_delayed, frame_clk_rising_edge;
//     always_ff @ (posedge Clk) begin
//         frame_clk_delayed <= frame_clk;
//         frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
//     end
//     // Update registers
//     always_ff @ (posedge Clk)
//     begin
//         if (Reset)
//         begin
//             Ball_X_Pos <= Ball_X_Center;
//             Ball_Y_Pos <= Ball_Y_Center;
//             Ball_X_Motion <= 10'd0;
//             Ball_Y_Motion <= 10'd0;
//             Ball_X_Progress <= 10'd0;
//             // monster_Y_Pos <= 10'd0;
//             // monster_X_Pos <= 10'd800;
//             // monster_X_Motion <= 10'd0;
//             // monster_Y_Motion <= 10'd0;
//             Bullet_X_Pos <= 10'd800;
//             Bullet_Y_Pos <= 10'd0;
//             Bullet_X_Motion <= 10'd0;
//             Bullet_Y_Motion <= 10'd0;
//
//         end
//         else
//         begin
//             Ball_X_Pos <= Ball_X_Pos_in;
//             Ball_Y_Pos <= Ball_Y_Pos_in;
//             Ball_X_Motion <= Ball_X_Motion_in;
//             Ball_Y_Motion <= Ball_Y_Motion_in;
//             Ball_X_Progress <= Ball_X_Progress_in;
//             //monster_X_Pos
//             Bullet_X_Pos <= Bullet_X_Pos_in;
//             Bullet_Y_Pos <= Bullet_Y_Pos_in;
//             Bullet_X_Motion <= Bullet_X_Motion_in;
//             Bullet_Y_Motion <= Bullet_Y_Motion_in;
//         end
//     end
//     //////// Do not modify the always_ff blocks. ////////
//
//     // You need to modify always_comb block.
//     always_comb
//     begin
//         // By default, keep motion and position unchanged
//         Ball_X_Pos_in = Ball_X_Pos;
//         Ball_Y_Pos_in = Ball_Y_Pos;
//         Ball_X_Motion_in = Ball_X_Motion;
//         Ball_Y_Motion_in = Ball_Y_Motion;
//         Ball_X_Progress_in = Ball_X_Progress;
//         Bullet_X_Pos_in = Bullet_X_Pos;
//         Bullet_Y_Pos_in = Bullet_Y_Pos;
//         Bullet_X_Motion_in = Bullet_X_Motion;
//         Bullet_Y_Motion_in = Bullet_Y_Motion;
//         // Update position and motion only at rising edge of frame clock
//         if (frame_clk_rising_edge)
//         begin
//             // Be careful when using comparators with "logic" datatype because compiler treats
//             //   both sides of the operator as UNSIGNED numbers.
//             // e.g. Ball_Y_Pos - Ball_Size <= sky
//             // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
//
//
//             // TODO: Add other boundary detections and handle keypress here.
//             begin // when bouncing disable keycode
//
//                 // 8'h16: begin // S = down
//                 //   Ball_Y_Motion_in = 10'd1;
//                 // end
//                 if (upOn) begin// W = up
//                   Ball_Y_Motion_in = ~(10'd10) + 1; // larger init velocity, no teleport; Motion should be treated as velocity instead of displacement
//                 end
//                 if(leftOn) begin// A = left
//                   Ball_Y_Motion_in = Ball_Y_Motion + gravity;
//                   if (Ball_X_Motion == 10'd0)
//                     Ball_X_Motion_in =  ~(10'd4) + 1;
//                   else
//     						      Ball_X_Motion_in = 10'd0;
//                 end
//                 if(rightOn) begin// D = right
//                   Ball_Y_Motion_in = Ball_Y_Motion + gravity;
//                   if (Ball_X_Motion == 10'd0)
//                     Ball_X_Motion_in =  10'd4;
//                   else
//                       Ball_X_Motion_in = 10'd0;
//                 end
//
//                 // if(zOn) begin
//                 //   Bullet_X_Pos_in = Ball_X_Pos + 10'd20;
//                 //   Bullet_Y_Pos_in = Ball_Y_Pos;
//                 // end
//                 else begin
//                     Ball_Y_Motion_in = Ball_Y_Motion + gravity; // use gravity wo/ inAir
//                     Ball_X_Motion_in = 10'd0; // FIX: clear xmotion by default to avoid undesirable xmotion
// 						    end
//             end
//
//             // Update the ball's position with its motion
//             Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
//             Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
//             if(( Ball_Y_Pos_in + Ball_Size >= ground ) && (~upOn) && ~(Ball_X_Pos_in > holeCenter - holeSize - 10'd15 && Ball_X_Pos_in < holeCenter + holeSize - 10'd15))  // FIX: use Ball_Y_Pos_in to avoid ball-under-ground frame
//               begin
//                 Ball_Y_Pos_in = ground - Ball_Size;  // 2's complement.
//                 if (Ball_Y_Motion != 10'b0)
//                   Ball_X_Motion_in = 10'd0;
//
//                 Ball_Y_Motion_in = 10'd0;
//               end
//             else if (( Ball_Y_Pos_in <= sky + Ball_Size ))  // Ball is at the top edge, BOUNCE!
//               begin
//                 Ball_Y_Pos_in = sky + Ball_Size;//if deleted: drop with no initial velocity in sky and accelerate after falling back
//                 Ball_Y_Motion_in = gravity;//bounce back behavior
//               end
//
//
//             if(Ball_X_Pos >= 10'd400 + Ball_Size && rightOn) begin
//               Ball_X_Pos_in = 10'd400 + Ball_Size;
//               Ball_X_Progress_in = Ball_X_Progress + Ball_X_Motion;
//             end
//
//             if(Ball_X_Pos <= 10'd0 + Ball_Size && leftOn) begin
//               Ball_X_Pos_in = Ball_Size;
//               //Ball_X_Progress_in = Ball_X_Progress + Ball_X_Motion;
//             end
//
//         end
//         if(Ball_X_Pos >= Ball_X_Progress + 10'd200)begin
//           if(Ball_X_Motion[9] == 0)begin
//             Ball_X_Progress_in = Ball_X_Progress + Ball_X_Motion;
//           end
//         end
//         /**************************************************************************************
//             ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
//             Hidden Question #2/2:
//                Notice that Ball_Y_Pos is updated using Ball_Y_Motion.
//               Will the new value of Ball_Y_Motion be used when Ball_Y_Pos is updated, or the old?
//               What is the difference between writing
//                 "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;" and
//                 "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion_in;"?
//               How will this impact behavior of the ball during a bounce, and how might that interact with a response to a keypress?
//               Give an answer in your Post-Lab.
//         **************************************************************************************/
//     end
//
//     // Compute whether the pixel corresponds to ball or background
//     /* Since the multiplicants are required to be signed, we have to first cast them
//        from logic to int (signed by default) before they are multiplied. */
//     int DistX, DistY, Size;
//     assign DistX = DrawX - Ball_X_Pos;
//     assign DistY = DrawY - Ball_Y_Pos;
//     assign Size = Ball_Size;
//     assign progress = Ball_X_Progress;
//     always_ff @ (posedge frame_clk) begin
//       if (Ball_X_Motion > Ball_X_Motion_in) begin
//         stopDirection = 1'b1;
//       end
//       else if (Ball_X_Motion < Ball_X_Motion_in) begin
//         stopDirection = 1'b0;
//       end
//       else begin
//         stopDirection = stopDirection;
//       end
//     end
//     //assign stopDirection = (Ball_X_Motion > Ball_X_Motion_in ) ? 1'b1 : 1'b0;
//     always_comb begin
//         if ( DistX <= Ball_Size && DistY < Ball_Size  )
//             is_avatar = 1'b1;
//         else
//             is_avatar = 1'b0;
//         /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while
//            the single line is quite powerful descriptively, it causes the synthesis tool to use up three
//            of the 12 available multipliers on the chip! */
//     end
//     // always_comb begin
//     //    if (((DrawX - Bullet_X_Pos) * (DrawX - Bullet_X_Pos) + (DrawY - Bullet_Y_Pos) * (DrawY - Bullet_Y_Pos)) <= 10'd5)
//     //       is_bullet = 1'd1;
//     //    else
//     //       is_bullet = 1'd0;
//     // end
//
//
//     // assign xDirection = (keycode == 8'h04) ? 1'd1 : 1'd0;
//     always_ff @ ( posedge frame_clk ) begin
// 	 // default
//        xDirection <= ~leftOn;
// 	     xFlag = (xCnt >= 6'd5);
//       if (Reset || xCnt >= 6'd10 || keycode == 8'd0) begin
//         xCnt = 10'd0;
//         // yFlag = 1'd0;
//       end
//       if ( leftOn || rightOn || downOn || upOn)  begin
//         // right
//         xCnt <= xCnt + 6'd1;
//       end
//     end
// endmodule
//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


// module  avatar ( input         Clk,                // 50 MHz clock
//                              Reset,              // Active-high reset signal
//                              frame_clk,          // The clock indicating a new frame (~60Hz)
//                input [9:0]   DrawX, DrawY, sky, ground, gravity,       // Current pixel coordinates
//                input [31:0]   keycode,
//                output[9:0]   Ball_X_Pos, Ball_Y_Pos,
//                output logic  is_avatar,             // Whether current pixel belongs to ball or background
//                output logic  xFlag,
//                output logic xDirection,
//                output logic stopDirection,
//                output logic [9:0] progress,
//                output logic die
//                //output logic leftOn, rightOn, upOn, downOn, zOn, xOn
//               );
//
//     parameter [9:0] Ball_X_Center = 10'd320;  // Center position on the X axis
//     parameter [9:0] Ball_Y_Center = 10'd240;  // Center position on the Y axis
//     parameter [9:0] Ball_X_Min = 10'd0;       // Leftmost point on the X axis
//     parameter [9:0] Ball_X_Max = 10'd639;     // Rightmost point on the X axis
//     parameter [9:0] Ball_X_Step = 10'd4;      // Step size on the X axis
//     parameter [9:0] Ball_Y_Step = 10'd10;      // Step size on the Y axis
//     parameter [9:0] Ball_Size = 10'd32;        // Ball size
//
//
//     logic [9:0] Bullet_X_Position, Bullet_X_Position_in;
//     logic [9:0] Bullet_Y_Position, Bullet_Y_Position_in;
//     logic [9:0] Bullet_X_Motion, Bullet_X_Motion_in;
//     logic [9:0] Bullet_Y_Motion, Bullet_Y_Motion_in;
//
//     logic [9:0] Ball_X_Motion,  Ball_Y_Motion; // registers Q
//     logic [9:0] Ball_X_Pos_in,  Ball_X_Motion_in,   Ball_Y_Pos_in,   Ball_Y_Motion_in; // tmp same as D
//     logic [9:0] Ball_X_Progress, Ball_X_Progress_in;
//
//     logic[5:0] xCnt;
//     logic[9:0] holeCenter;
//     logic[9:0] holeSize;
//     assign holeSize = 10'd32;
//     assign holeCenter = 10'd160 - progress;
//     assign die = Ball_Y_Pos > 10'd480;
//
//
//     //////// Do not modify the always_ff blocks. ////////
//     // Detect rising edge of frame_clk
//
//     // logic [9:0] monster_X_Motion;
//     // logic [9:0] monster_Y_Motion;
//     // logic [9:0] monster_X_Pos;
//     // logic [9:0] monster_Y_Pos;
//     //
//     assign upOn = (keycode[31:24] == 8'd82 | keycode[23:16] == 8'd82 | keycode[15: 8] == 8'd82 | keycode[ 7: 0] == 8'd82);
//
//     assign downOn = (keycode[31:24] == 8'd81 | keycode[23:16] == 8'd81 | keycode[15: 8] == 8'd81 | keycode[ 7: 0] == 8'd81);
//
//     assign leftOn = (keycode[31:24] == 8'd80 | keycode[23:16] == 8'd80 | keycode[15: 8] == 8'd80 | keycode[ 7: 0] == 8'd80);
//
//     assign rightOn = (keycode[31:24] == 8'd79 | keycode[23:16] == 8'd79 | keycode[15: 8] == 8'd79 | keycode[ 7: 0] == 8'd79);
//
//
//     // jump
//     assign zOn = (keycode[31:24] == 8'd29 | keycode[23:16] == 8'd29 | keycode[15: 8] == 8'd29 | keycode[ 7: 0] == 8'd29);
//     // fire
//     assign xOn = (keycode[31:24] == 8'd27 | keycode[23:16] == 8'd27 | keycode[15: 8] == 8'd27 | keycode[ 7: 0] == 8'd27);
//
//     logic frame_clk_delayed, frame_clk_rising_edge;
//     always_ff @ (posedge Clk) begin
//         frame_clk_delayed <= frame_clk;
//         frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
//     end
//     // Update registers
//     always_ff @ (posedge Clk)
//     begin
//         if (Reset)
//         begin
//             Ball_X_Pos <= Ball_X_Center;
//             Ball_Y_Pos <= Ball_Y_Center;
//             Ball_X_Motion <= 10'd0;
//             Ball_Y_Motion <= 10'd0;
//             Ball_X_Progress <= 10'd0;
//             // monster_Y_Pos <= 10'd0;
//             // monster_X_Pos <= 10'd800;
//             // monster_X_Motion <= 10'd0;
//             // monster_Y_Motion <= 10'd0;
//             Bullet_X_Position <= 10'd800;
//             Bullet_Y_Position <= 10'd0;
//         end
//         else
//         begin
//             Ball_X_Pos <= Ball_X_Pos_in;
//             Ball_Y_Pos <= Ball_Y_Pos_in;
//             Ball_X_Motion <= Ball_X_Motion_in;
//             Ball_Y_Motion <= Ball_Y_Motion_in;
//             Ball_X_Progress <= Ball_X_Progress_in;
//             //monster_X_Pos
//
//         end
//     end
//     //////// Do not modify the always_ff blocks. ////////
//
//     // You need to modify always_comb block.
//     always_comb
//     begin
//         // By default, keep motion and position unchanged
//         Ball_X_Pos_in = Ball_X_Pos;
//         Ball_Y_Pos_in = Ball_Y_Pos;
//         Ball_X_Motion_in = Ball_X_Motion;
//         Ball_Y_Motion_in = Ball_Y_Motion;
//         Ball_X_Progress_in = Ball_X_Progress;
//         Bullet_X_Position_in = Bullet_X_Position;
//         Bullet_Y_Position_in = Bullet_Y_Position;
//
//         // Update position and motion only at rising edge of frame clock
//         if (frame_clk_rising_edge)
//         begin
//             // Be careful when using comparators with "logic" datatype because compiler treats
//             //   both sides of the operator as UNSIGNED numbers.
//             // e.g. Ball_Y_Pos - Ball_Size <= sky
//             // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
//
//
//             // TODO: Add other boundary detections and handle keypress here.
//             begin // when bouncing disable keycode
//
//                 // 8'h16: begin // S = down
//                 //   Ball_Y_Motion_in = 10'd1;
//                 // end
//                 if (keycode == 8'h1a) begin// W = up
//                   Ball_Y_Motion_in = ~(10'd10) + 1; // larger init velocity, no teleport; Motion should be treated as velocity instead of displacement
//                 end
//                 if(keycode == 8'h04) begin// A = left
//                   Ball_Y_Motion_in = Ball_Y_Motion + gravity;
//                   if (Ball_X_Motion == 10'd0)
//                     Ball_X_Motion_in =  ~(10'd4) + 1;
//                   else
//     						      Ball_X_Motion_in = 10'd0;
//                 end
//                 if(keycode == 8'h07) begin// D = right
//                   Ball_Y_Motion_in = Ball_Y_Motion + gravity;
//                   if (Ball_X_Motion == 10'd0)
//                     Ball_X_Motion_in =  10'd4;
//                   else
//                       Ball_X_Motion_in = 10'd0;
//                 end
//                 else
//     						  begin
//                         Ball_Y_Motion_in = Ball_Y_Motion + gravity; // use gravity wo/ inAir
//                         Ball_X_Motion_in = 10'd0; // FIX: clear xmotion by default to avoid undesirable xmotion
//     						  end
//             end
//
//             // Update the ball's position with its motion
//             Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
//             Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
//             if(( Ball_Y_Pos_in + Ball_Size >= ground ) && ~(Ball_X_Pos_in > holeCenter - holeSize - 10'd15 && Ball_X_Pos_in < holeCenter + holeSize - 10'd15))  // FIX: use Ball_Y_Pos_in to avoid ball-under-ground frame
//               begin
//                 Ball_Y_Pos_in = ground - Ball_Size;  // 2's complement.
//                 if (Ball_Y_Motion != 10'b0)
//                   Ball_X_Motion_in = 10'd0;
//
//                 Ball_Y_Motion_in = 10'd0;
//               end
//             else if (( Ball_Y_Pos_in <= sky + Ball_Size ))  // Ball is at the top edge, BOUNCE!
//               begin
//                 Ball_Y_Pos_in = sky + Ball_Size;//if deleted: drop with no initial velocity in sky and accelerate after falling back
//                 Ball_Y_Motion_in = gravity;//bounce back behavior
//               end
//
//
//             if(Ball_X_Pos >= 10'd400 + Ball_Size && keycode == 8'h07) begin
//               Ball_X_Pos_in = 10'd400 + Ball_Size;
//               Ball_X_Progress_in = Ball_X_Progress + Ball_X_Motion;
//             end
//
//             if(Ball_X_Pos <= 10'd0 + Ball_Size && keycode == 8'h04) begin
//               Ball_X_Pos_in = Ball_Size;
//               //Ball_X_Progress_in = Ball_X_Progress + Ball_X_Motion;
//             end
//
//         end
//         if(Ball_X_Pos >= Ball_X_Progress + 10'd200)begin
//           if(Ball_X_Motion[9] == 0)begin
//             Ball_X_Progress_in = Ball_X_Progress + Ball_X_Motion;
//           end
//         end
//         /**************************************************************************************
//             ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
//             Hidden Question #2/2:
//                Notice that Ball_Y_Pos is updated using Ball_Y_Motion.
//               Will the new value of Ball_Y_Motion be used when Ball_Y_Pos is updated, or the old?
//               What is the difference between writing
//                 "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;" and
//                 "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion_in;"?
//               How will this impact behavior of the ball during a bounce, and how might that interact with a response to a keypress?
//               Give an answer in your Post-Lab.
//         **************************************************************************************/
//     end
//
//     // Compute whether the pixel corresponds to ball or background
//     /* Since the multiplicants are required to be signed, we have to first cast them
//        from logic to int (signed by default) before they are multiplied. */
//     int DistX, DistY, Size;
//     assign DistX = DrawX - Ball_X_Pos;
//     assign DistY = DrawY - Ball_Y_Pos;
//     assign Size = Ball_Size;
//     assign progress = Ball_X_Progress;
//     always_ff @ (posedge frame_clk) begin
//       if (Ball_X_Motion > Ball_X_Motion_in) begin
//         stopDirection = 1'b1;
//       end
//       else if (Ball_X_Motion < Ball_X_Motion_in) begin
//         stopDirection = 1'b0;
//       end
//       else begin
//         stopDirection = stopDirection;
//       end
//     end
//     //assign stopDirection = (Ball_X_Motion > Ball_X_Motion_in ) ? 1'b1 : 1'b0;
//     always_comb begin
//         if ( DistX <= Ball_Size && DistY < Ball_Size  )
//             is_avatar = 1'b1;
//         else
//             is_avatar = 1'b0;
//         /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while
//            the single line is quite powerful descriptively, it causes the synthesis tool to use up three
//            of the 12 available multipliers on the chip! */
//     end
//
//
//     // assign xDirection = (keycode == 8'h04) ? 1'd1 : 1'd0;
//     always_ff @ ( posedge frame_clk ) begin
// 	 // default
//        xDirection <= ~(keycode == 8'h04);
// 	     xFlag = (xCnt >= 6'd5);
//       if (Reset || xCnt >= 6'd10 || keycode == 8'd0) begin
//         xCnt = 10'd0;
//         // yFlag = 1'd0;
//       end
//       if ( keycode != 8'h0)  begin
//         // right
//         xCnt <= xCnt + 6'd1;
//       end
//     end
// endmodule


//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  avatar ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
                             aliveBoss,
               input [9:0]   DrawX, DrawY, sky, ground, gravity, Boss_X_Pos, Boss_Y_Pos,      // Current pixel coordinates
               input [31:0]   keycode,
               output[9:0]   Ball_X_Pos, Ball_Y_Pos, progress,
               output logic  is_avatar,             // Whether current pixel belongs to ball or background
               output logic  xFlag,
               output logic xDirection,
               output logic stopDirection,
               output logic alive,
               output logic [1:0] health,
               output logic [5:0] nohurt
              );

    parameter [9:0] Ball_X_Center = 10'd100;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 10'd240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Ball_X_Step = 10'd8;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd10;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd32;        // Ball size

    logic [9:0] Ball_X_Motion,  Ball_Y_Motion; // registers Q
    logic [9:0] Ball_X_Pos_in,  Ball_X_Motion_in,   Ball_Y_Pos_in,   Ball_Y_Motion_in; // tmp same as D
    logic [19:0] xDist;
    logic [19:0] yDist;
    logic [19:0] abDist;
    logic [9:0] Ball_X_Progress, Ball_X_Progress_in;
    assign abDist = xDist + yDist; // squared dist
    assign progress = Ball_X_Progress;
    signedMult10 Mult10inst0 (.A(Ball_X_Pos-Boss_X_Pos), .B(Ball_X_Pos-Boss_X_Pos), .ans(xDist));
    signedMult10 Mult10inst1 (.A(Ball_Y_Pos-Boss_Y_Pos), .B(Ball_Y_Pos-Boss_Y_Pos), .ans(yDist));

    logic[5:0] xCnt;
    logic Zen;
    //logic [1:0] health;
    assign Zen = (Ball_Y_Pos + 10'd100 > ground && Ball_Y_Pos < ground + 10'd50);
    //assign alive = (health > 2'd0);
    //logic [5:0] nohurt;

    assign upOn = (keycode[31:24] == 8'd82 | keycode[23:16] == 8'd82 | keycode[15: 8] == 8'd82 | keycode[ 7: 0] == 8'd82);
    //
    assign downOn = (keycode[31:24] == 8'd81 | keycode[23:16] == 8'd81 | keycode[15: 8] == 8'd81 | keycode[ 7: 0] == 8'd81);

    assign leftOn = (keycode[31:24] == 8'd80 | keycode[23:16] == 8'd80 | keycode[15: 8] == 8'd80 | keycode[ 7: 0] == 8'd80);

    assign rightOn = (keycode[31:24] == 8'd79 | keycode[23:16] == 8'd79 | keycode[15: 8] == 8'd79 | keycode[ 7: 0] == 8'd79);
        // use as reset button
    assign testhurt = (keycode[31:24] == 8'h28 | keycode[23:16] == 8'h28 | keycode[15: 8] == 8'h28 | keycode[ 7: 0] == 8'h28);
        // jump
    assign zOn = (keycode[31:24] == 8'd29 | keycode[23:16] == 8'd29 | keycode[15: 8] == 8'd29 | keycode[ 7: 0] == 8'd29);
        // fire
    assign xOn = (keycode[31:24] == 8'd27 | keycode[23:16] == 8'd27 | keycode[15: 8] == 8'd27 | keycode[ 7: 0] == 8'd27);
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk

    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= 10'd0;
            Ball_X_Progress <= 10'd0;
            //hurt <= 1'b0;
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
            Ball_X_Progress <= Ball_X_Progress_in;
        end


    end
    assign alive = ~(health ==2'd0);

    // collision logic
	 always_ff @(posedge frame_clk) begin
     //start with 3 health, vurnerable, alive
		if(Reset || testhurt) begin
			health <= 2'd3;
      nohurt <= 6'd1;
		end
    // when hurt and vurnerable, decrease health set invurnerable
		if( abDist <= 20'd2304 && nohurt == 6'd0 && Ball_X_Progress >= 10'd640 && aliveBoss) begin  //boss size hit detection.  (Ball_X_Pos-Boss_X_Pos)*(Ball_X_Pos-Boss_X_Pos) + (Ball_Y_Pos-Boss_Y_Pos)*(Ball_Y_Pos-Boss_Y_Pos) <= 10'd80 ||
              health <= health - 2'd1;
              nohurt <= 6'd1;
            end
     // invurnerable last for 60 cyc
		 if(nohurt != 6'd0 && nohurt < 6'd60) begin
              nohurt <= nohurt + 6'd1;
      end
    if(nohurt == 6'd60 )
      nohurt <= 6'd0;
     //
	 end

    //////// Do not modify the always_ff blocks. ////////

    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Ball_X_Pos_in = Ball_X_Pos;
        Ball_Y_Pos_in = Ball_Y_Pos;
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;
        Ball_X_Progress_in = Ball_X_Progress;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            // Be careful when using comparators with "logic" datatype because compiler treats
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Ball_Y_Pos - Ball_Size <= sky
            // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.

            // if(~alive)begin
            //   die = 1'b1;
            // end

            // TODO: Add other boundary detections and handle keypress here.

            if(alive) begin // when bouncing disable keycode

                // 8'h16: begin // S = down
                //   Ball_Y_Motion_in = 10'd1;
                // end
                // KEYCODE CONDITION
                if (zOn && Zen) begin// W = up
                  Ball_Y_Motion_in = ~(10'd10) + 1; // larger init velocity, no teleport; Motion should be treated as velocity instead of displacement
                end
                else if (leftOn) begin// A = left
                  Ball_Y_Motion_in = Ball_Y_Motion + gravity;
                  if (Ball_X_Motion == 10'd0)
                    Ball_X_Motion_in =  ~(Ball_X_Step) + 1;
                  else
    						      Ball_X_Motion_in = 10'd0;
                end
                else if (rightOn) begin// D = right
                  Ball_Y_Motion_in = Ball_Y_Motion + gravity;
                  if (Ball_X_Motion == 10'd0)
                    Ball_X_Motion_in =  Ball_X_Step;
                  else
                      Ball_X_Motion_in = 10'd0;
                end
                else
						      begin
                    Ball_Y_Motion_in = Ball_Y_Motion + gravity; // use gravity wo/ inAir
                    Ball_X_Motion_in = 10'd0; // FIX: clear xmotion by default to avoid undesirable xmotion
						      end

            end

            // Update the ball's position with its motion
            Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
            Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
            // OVERRIDE CONDITION
            if(( Ball_Y_Pos_in + Ball_Size >= ground ) && (!zOn))  // FIX: use Ball_Y_Pos_in to avoid ball-under-ground frame
              begin
                Ball_Y_Pos_in = ground - Ball_Size;  // 2's complement.
                if (Ball_Y_Motion != 10'b0)
                  Ball_X_Motion_in = 10'd0;

                Ball_Y_Motion_in = 10'd0;
              end
            else if (( Ball_Y_Pos_in <= sky + Ball_Size ))  // Ball is at the top edge, BOUNCE!
              begin
                Ball_Y_Pos_in = sky + Ball_Size;//if deleted: drop with no initial velocity in sky and accelerate after falling back
                Ball_Y_Motion_in = gravity;//bounce back behavior
              end
              //  limit Ball_X_Pos
              if(Ball_X_Pos >= 10'd400 + Ball_Size && rightOn && Ball_X_Progress <= 10'd640)
                 begin
                   Ball_X_Pos_in = 10'd400 + Ball_Size;
                   Ball_X_Progress_in = Ball_X_Progress + Ball_X_Motion;
                 end
              if(Ball_X_Pos >= Ball_X_Progress + 10'd200 && Ball_X_Progress <= 10'd640)
                begin
                 if(Ball_X_Motion[9] == 0)
                   begin
                     Ball_X_Progress_in = Ball_X_Progress + Ball_X_Step;
                   end
               end
               if(Ball_X_Pos_in <= 10'd0 && (~rightOn))
                 begin
                   Ball_X_Pos_in = 10'd0;
                 end
               else if(Ball_X_Pos_in + Ball_Size >= 10'd640 && (~leftOn))
                 begin
                   Ball_X_Pos_in = 10'd640 - Ball_Size;
                 end

        end

        /**************************************************************************************
            ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
            Hidden Question #2/2:
               Notice that Ball_Y_Pos is updated using Ball_Y_Motion.
              Will the new value of Ball_Y_Motion be used when Ball_Y_Pos is updated, or the old?
              What is the difference between writing
                "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;" and
                "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion_in;"?
              How will this impact behavior of the ball during a bounce, and how might that interact with a response to a keypress?
              Give an answer in your Post-Lab.
        **************************************************************************************/
    end

    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
    assign Size = Ball_Size;
    always_ff @ (posedge frame_clk) begin
      if (Ball_X_Motion > Ball_X_Motion_in) begin
        stopDirection = 1'b1;
      end
      else if (Ball_X_Motion < Ball_X_Motion_in) begin
        stopDirection = 1'b0;
      end
      else begin
        stopDirection = stopDirection;
      end
    end
    //assign stopDirection = (Ball_X_Motion > Ball_X_Motion_in ) ? 1'b1 : 1'b0;
    always_comb begin
        if ( DistX <= Ball_Size && DistY < Ball_Size  )
            is_avatar = 1'b1;
        else
            is_avatar = 1'b0;
        /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
    end


    // assign xDirection = (keycode == 8'h04) ? 1'd1 : 1'd0;
    always_ff @ ( posedge frame_clk ) begin
	 // default
       xDirection <= ~leftOn;
	     xFlag = (xCnt >= 6'd5);
      if (Reset || xCnt >= 6'd10 || (~leftOn && ~rightOn && ~zOn) ) begin
        xCnt = 10'd0;
        // yFlag = 1'd0;
      end
      if ( leftOn || rightOn || zOn )  begin
        // right
        xCnt <= xCnt + 6'd1;
      end
    end
endmodule
