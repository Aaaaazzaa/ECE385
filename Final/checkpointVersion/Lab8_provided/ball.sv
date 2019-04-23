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
               input [9:0]   DrawX, DrawY, sky, ground, gravity,       // Current pixel coordinates
               input [7:0]   keycode,
               output[9:0]   Ball_X_Pos, Ball_Y_Pos,
               output logic  is_avatar,             // Whether current pixel belongs to ball or background
               output logic  xFlag,
               output logic xDirection
              );

    parameter [9:0] Ball_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 10'd240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Ball_X_Step = 10'd2;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd10;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd16;        // Ball size

    logic [9:0] Ball_X_Motion,  Ball_Y_Motion; // registers Q
    logic [9:0] Ball_X_Pos_in,  Ball_X_Motion_in,   Ball_Y_Pos_in,   Ball_Y_Motion_in; // tmp same as D

    logic[5:0] xCnt;
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
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
        end
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
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            // Be careful when using comparators with "logic" datatype because compiler treats
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Ball_Y_Pos - Ball_Size <= sky
            // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.


            // TODO: Add other boundary detections and handle keypress here.
            begin // when bouncing disable keycode
              unique case (keycode)
                // 8'h16: begin // S = down
                //   Ball_Y_Motion_in = 10'd1;
                // end
                8'h1a: begin// W = up
                  Ball_Y_Motion_in = ~(10'd10) + 1; // larger init velocity, no teleport; Motion should be treated as velocity instead of displacement
                end
                8'h04: begin// A = left
                  Ball_Y_Motion_in = Ball_Y_Motion + gravity;
                  if (Ball_X_Motion == 10'd0)
                    Ball_X_Motion_in =  ~(10'd2) + 1;
                  else
    						      Ball_X_Motion_in = 10'd0;
                end
                8'h07: begin// D = right
                  Ball_Y_Motion_in = Ball_Y_Motion + gravity;
                  if (Ball_X_Motion == 10'd0)
                    Ball_X_Motion_in =  10'd2;
                  else
                      Ball_X_Motion_in = 10'd0;
                end
                default:
						      begin
                    Ball_Y_Motion_in = Ball_Y_Motion + gravity; // use gravity wo/ inAir
                    Ball_X_Motion_in = 10'd0; // FIX: clear xmotion by default to avoid undesirable xmotion
						      end
              endcase
            end

            // Update the ball's position with its motion
            Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
            Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
            if(( Ball_Y_Pos_in + Ball_Size >= ground ) && (keycode != 8'h1a))  // FIX: use Ball_Y_Pos_in to avoid ball-under-ground frame
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
    always_comb begin
        if ( DistX <= Ball_Size && DistY <= Ball_Size  )
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
       xDirection <= ~(keycode == 8'h04);
	     xFlag = (xCnt >= 6'd5);
      if (Reset || xCnt >= 6'd10 || keycode == 8'd0) begin
        xCnt = 10'd0;
        // yFlag = 1'd0;
      end
      if ( keycode != 8'd0)  begin
        // right
        xCnt <= xCnt + 6'd1;
      end
    end
endmodule
