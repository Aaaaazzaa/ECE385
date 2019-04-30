module  boss ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY, sky, ground, gravity,       // Current pixel coordinates
               input [31:0]   keycode,
               input [9:0]  Ball_X_Pos, Ball_Y_Pos,
               input [9:0]  progress,
               output[9:0]   Boss_X_Pos, Boss_Y_Pos,
               output logic  is_boss,             // Whether current pixel belongs to Boss or background
               output logic  xFlagBoss
               //output logic xDirectionBoss,
               //output logic stopDirectionBoss
              );

    parameter [9:0] Boss_X_Center = 10'd100;  // Center position on the X axis
    parameter [9:0] Boss_Y_Center = 10'd240;  // Center position on the Y axis
    parameter [9:0] Boss_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Boss_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Boss_X_Step = 10'd2;      // Step size on the X axis
    parameter [9:0] Boss_Y_Step = 10'd5;      // Step size on the Y axis
    parameter [9:0] Boss_Size = 10'd64;        // Boss size
    logic upOn, leftOn, rightOn;
    logic [9:0] Boss_X_Motion,  Boss_Y_Motion; // registers Q
    logic [9:0] Boss_X_Pos_in,  Boss_X_Motion_in,   Boss_Y_Pos_in,   Boss_Y_Motion_in; // tmp same as D
    assign upOn = (keycode[31:24] == 8'h1a | keycode[23:16] == 8'h1a | keycode[15:8] == 8'h1a | keycode[7:0] == 8'h1a);
    assign leftOn = (keycode[31:24] == 8'h04 | keycode[23:16] == 8'h04 | keycode[15:8] == 8'h04 | keycode[7:0] == 8'h04);
    assign rightOn = (keycode[31:24] == 8'h07 | keycode[23:16] == 8'h07 | keycode[15:8] == 8'h07 | keycode[7:0] == 8'h07);


    //
    logic [19:0] abDist;
    logic [19:0] xDist;
    logic [19:0] yDist;
    assign abDist = xDist + yDist; // squared dist
    signedMult10 Mult10inst2 (.A(Ball_X_Pos-Boss_X_Pos), .B(Ball_X_Pos-Boss_X_Pos), .ans(xDist));
    signedMult10 Mult10inst3 (.A(Ball_Y_Pos-Boss_Y_Pos), .B(Ball_Y_Pos-Boss_Y_Pos), .ans(yDist));
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
            Boss_X_Pos <= Boss_X_Center;
            Boss_Y_Pos <= Boss_Y_Center;
            Boss_X_Motion <= 10'd0;
            Boss_Y_Motion <= 10'd0;
        end
        else
        begin
            Boss_X_Pos <= Boss_X_Pos_in;
            Boss_Y_Pos <= Boss_Y_Pos_in;
            Boss_X_Motion <= Boss_X_Motion_in;
            Boss_Y_Motion <= Boss_Y_Motion_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////

    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Boss_X_Pos_in = Boss_X_Pos;
        Boss_Y_Pos_in = Boss_Y_Pos;
        Boss_X_Motion_in = Boss_X_Motion;
        Boss_Y_Motion_in = Boss_Y_Motion;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            // Be careful when using comparators with "logic" datatype because compiler treats
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Boss_Y_Pos - Boss_Size <= sky
            // If Boss_Y_Pos is 0, then Boss_Y_Pos - Boss_Size will not be -4, but rather a large positive number.


            // TODO: Add other boundary detections and handle keypress here.
            begin // when bouncing disable keycode
                if (upOn) begin// W = up
                  Boss_Y_Motion_in = ~(Boss_Y_Step) + 1; // larger init velocity, no teleport; Motion should be treated as velocity instead of displacement
                end
                // too far and
                else if (abDist > 20'd120000 && Boss_X_Pos > Ball_X_Pos) begin// A = left
                  Boss_Y_Motion_in = Boss_Y_Motion;
                  //if (Boss_X_Motion == 10'd0)
                    Boss_X_Motion_in =  ~(Boss_X_Step) + 1;
                  //else
    						      //Boss_X_Motion_in = 10'd0;
                end
                else if (abDist > 20'd120000 && Boss_X_Pos < Ball_X_Pos) begin// D = right
                  Boss_Y_Motion_in = Boss_Y_Motion;
                  //if (Boss_X_Motion == 10'd0)
                    Boss_X_Motion_in =  Boss_X_Step;
                  //else
                      //Boss_X_Motion_in = 10'd0;
                end
                //if (startRush) begin

                // end
                else
						      begin
                    Boss_Y_Motion_in = Boss_Y_Motion; // use gravity wo/ inAir
                    Boss_X_Motion_in = Boss_X_Motion; // FIX: clear xmotion by default to avoid undesirable xmotion
						      end
            end

            // Update the Boss's position with its motion
            Boss_X_Pos_in = Boss_X_Pos + Boss_X_Motion;
            Boss_Y_Pos_in = Boss_Y_Pos + Boss_Y_Motion;
            if(( Boss_Y_Pos_in + Boss_Size >= ground ) && (~upOn))  // FIX: use Boss_Y_Pos_in to avoid Boss-under-ground frame
              begin
                Boss_Y_Pos_in = ground - Boss_Size;  // 2's complement.
                Boss_Y_Motion_in = ~Boss_Y_Motion_in + 10'd1;
                // if (Boss_Y_Motion != 10'b0)
                //   Boss_X_Motion_in = 10'd0;
                //
                // Boss_Y_Motion_in = 10'd0;
              end
            if (( Boss_Y_Pos_in <= sky ))  // Boss is at the top edge, BOUNCE!
              begin
                Boss_Y_Pos_in = sky;//if deleted: drop with no initial velocity in sky and accelerate after falling back
                Boss_Y_Motion_in = ~Boss_Y_Motion_in + 10'd1;//bounce back behavior
              end
            if (Boss_X_Pos_in <= 10'd0) begin
              Boss_X_Pos_in = 10'd0;  // 2's complement.
              Boss_X_Motion_in = ~Boss_X_Motion_in + 10'd1;
            end
            if (Boss_X_Pos_in + Boss_Size >= 10'd640) begin
              Boss_X_Pos_in = 10'd640 - Boss_Size;  // 2's complement.
              Boss_X_Motion_in = ~Boss_X_Motion_in + 10'd1;
            end
            if (Boss_Y_Motion_in > 10'd12 || Boss_Y_Motion_in < 10'd12) begin
              Boss_Y_Motion_in = Boss_Y_Motion_in[9] ? -10'd12 : 10'd12;
            end
        end

        /**************************************************************************************
            ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
            Hidden Question #2/2:
               Notice that Boss_Y_Pos is updated using Boss_Y_Motion.
              Will the new value of Boss_Y_Motion be used when Boss_Y_Pos is updated, or the old?
              What is the difference between writing
                "Boss_Y_Pos_in = Boss_Y_Pos + Boss_Y_Motion;" and
                "Boss_Y_Pos_in = Boss_Y_Pos + Boss_Y_Motion_in;"?
              How will this impact behavior of the Boss during a bounce, and how might that interact with a response to a keypress?
              Give an answer in your Post-Lab.
        **************************************************************************************/
    end

    // Compute whether the pixel corresponds to Boss or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - Boss_X_Pos;
    assign DistY = DrawY - Boss_Y_Pos;
    assign Size = Boss_Size;
    // undirected
    // always_ff @ (posedge frame_clk) begin
    //   if (Boss_X_Motion > Boss_X_Motion_in) begin
    //     stopDirection = 1'b1;
    //   end
    //   else if (Boss_X_Motion < Boss_X_Motion_in) begin
    //     stopDirection = 1'b0;
    //   end
    //   else begin
    //     stopDirection = stopDirection;
    //   end
    // end
    //assign stopDirection = (Boss_X_Motion > Boss_X_Motion_in ) ? 1'b1 : 1'b0;
    always_comb begin
        if ( DistX <= Boss_Size && DistY < Boss_Size && progress >= 10'd640  )
            is_boss = 1'b1;
        else
            is_boss = 1'b0;
        /* The Boss's (pixelated) circle is generated using the standard circle formula.  Note that while
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
    end


    // assign xDirection = (keycode == 8'h04) ? 1'd1 : 1'd0;
    // boss will always spinning
    always_ff @ ( posedge frame_clk ) begin
	 // default
       //xDirection <= ~(rightOn);
	     xFlagBoss = (xCnt >= 6'd3);
      if (Reset || xCnt >= 6'd6 ) begin
        xCnt = 10'd0;
        // yFlag = 1'd0;
      end
      else begin
        // right
        xCnt <= xCnt + 6'd1;
      end
    end
endmodule
