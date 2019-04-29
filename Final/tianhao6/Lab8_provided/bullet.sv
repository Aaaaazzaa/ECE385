module  bullet ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,      // Current pixel coordinates
               input [31:0]   keycode,
               input [9:0]  Ball_X_Pos, Ball_Y_Pos,
               input [9:0]  Boss_X_Pos, Boss_Y_Pos,
               input        xDirection,
               output[9:0]   Bullet_X_Pos, Bullet_Y_Pos,
               output logic  is_bullet,             // Whether current pixel belongs to Bullet or background
               output logic  xFlagBullet,
               output logic Bullet_X_Dir, aliveBoss,
               output [2:0] lifeBoss
               //output logic xDirectionBullet,
               //output logic stopDirectionBullet
              );


    parameter [9:0] Bullet_X_Step = 10'd20;      // Step size on the X axis
    parameter [9:0] Bullet_Size = 10'd16;        // Bullet size
    logic [9:0] Bullet_X_Motion,  Bullet_Y_Motion; // registers Q
    logic [9:0] Bullet_X_Pos_in,  Bullet_X_Motion_in,   Bullet_Y_Pos_in,   Bullet_Y_Motion_in; // tmp same as D
    logic Bullet_X_Dir_in;
    logic xOn;
    assign xOn = (keycode[31:24] == 8'h1b | keycode[23:16] == 8'h1b | keycode[15: 8] == 8'h1b | keycode[ 7: 0] == 8'h1b);
    assign testhurt =  (keycode[31:24] == 8'h28 | keycode[23:16] == 8'h28 | keycode[15: 8] == 8'h28 | keycode[ 7: 0] == 8'h28);

    //
    logic [19:0] bbDist;
    logic [19:0] xDist;
    logic [19:0] yDist;
    assign bbDist = xDist + yDist; // squared dist
    signedMult10 Mult10inst2 (.A(Boss_X_Pos-Bullet_X_Pos), .B(Boss_X_Pos-Bullet_X_Pos), .ans(xDist));
    signedMult10 Mult10inst3 (.A(Boss_Y_Pos-Bullet_Y_Pos), .B(Boss_Y_Pos-Bullet_Y_Pos), .ans(yDist));
    logic[5:0] xCnt;
    // bosslife
    always_ff @ (posedge frame_clk ) begin
      if (Reset || testhurt) begin
        lifeBoss <= 3'd7;
      end
      else if (bbDist <= 20'd1024) begin
        lifeBoss <= lifeBoss - 20'd1;
      end
    end
    assign aliveBoss = lifeBoss > 3'd0;
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
        if (Reset || testhurt)
        begin
            Bullet_X_Pos <= 10'd700;
            Bullet_Y_Pos <= 10'd0;
            Bullet_X_Motion <= 10'd0;
            Bullet_Y_Motion <= 10'd0;
            Bullet_X_Dir <= 10'd0;
        end
        else
        begin
            Bullet_X_Pos <= Bullet_X_Pos_in;
            Bullet_Y_Pos <= Bullet_Y_Pos_in;
            Bullet_X_Motion <= Bullet_X_Motion_in;
            Bullet_Y_Motion <= Bullet_Y_Motion_in;
            Bullet_X_Dir <= Bullet_X_Dir_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////

    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Bullet_X_Pos_in = Bullet_X_Pos;
        Bullet_Y_Pos_in = Bullet_Y_Pos;
        Bullet_X_Motion_in = Bullet_X_Motion;
        Bullet_Y_Motion_in = Bullet_Y_Motion;
        Bullet_X_Dir_in = Bullet_X_Dir;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            // Be careful when using comparators with "logic" datatype because compiler treats
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Bullet_Y_Pos - Bullet_Size <= sky
            // If Bullet_Y_Pos is 0, then Bullet_Y_Pos - Bullet_Size will not be -4, but rather a large positive number.


            // TODO: Add other boundary detections and handle keypress here.
            Bullet_X_Pos_in = Bullet_X_Pos + Bullet_X_Motion;
            Bullet_Y_Pos_in = Bullet_Y_Pos + Bullet_Y_Motion;
            if (Reset || Bullet_X_Pos > 10'd640 || Bullet_X_Pos < 10'd0 || Bullet_Y_Pos > 10'd480 || Bullet_Y_Pos < 10'd0) begin
              Bullet_X_Pos_in = 10'd700;
              Bullet_Y_Pos_in = 10'd0;
              Bullet_X_Motion_in = 10'd0;
              Bullet_Y_Motion_in = 10'd0;
            end
            // if not fired and press fire
            if (xOn && Bullet_X_Pos == 10'd700) begin
              Bullet_X_Pos_in = Ball_X_Pos + 10'd10;
              Bullet_Y_Pos_in = Ball_Y_Pos;
              Bullet_X_Motion_in = (~xDirection) ? ~Bullet_X_Step +10'd1 : Bullet_X_Step;
              Bullet_X_Dir_in = xDirection;
            end
        end

        /**************************************************************************************
            ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
            Hidden Question #2/2:
               Notice that Bullet_Y_Pos is updated using Bullet_Y_Motion.
              Will the new value of Bullet_Y_Motion be used when Bullet_Y_Pos is updated, or the old?
              What is the difference between writing
                "Bullet_Y_Pos_in = Bullet_Y_Pos + Bullet_Y_Motion;" and
                "Bullet_Y_Pos_in = Bullet_Y_Pos + Bullet_Y_Motion_in;"?
              How will this impact behavior of the Bullet during a bounce, and how might that interact with a response to a keypress?
              Give an answer in your Post-Lab.
        **************************************************************************************/
    end

    // Compute whether the pixel corresponds to Bullet or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - Bullet_X_Pos;
    assign DistY = DrawY - Bullet_Y_Pos;
    assign Size = Bullet_Size;
    // undirected
    // always_ff @ (posedge frame_clk) begin
    //   if (Bullet_X_Motion > Bullet_X_Motion_in) begin
    //     stopDirection = 1'b1;
    //   end
    //   else if (Bullet_X_Motion < Bullet_X_Motion_in) begin
    //     stopDirection = 1'b0;
    //   end
    //   else begin
    //     stopDirection = stopDirection;
    //   end
    // end
    //assign stopDirection = (Bullet_X_Motion > Bullet_X_Motion_in ) ? 1'b1 : 1'b0;
    always_comb begin
        if ( DistX <= Bullet_Size && DistY < Bullet_Size  )
            is_bullet = 1'b1;
        else
            is_bullet = 1'b0;
        /* The Bullet's (pixelated) circle is generated using the standard circle formula.  Note that while
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
    end


    // assign xDirection = (keycode == 8'h04) ? 1'd1 : 1'd0;
    // Bullet will always spinning
    always_ff @ ( posedge frame_clk ) begin
	 // default
       //xDirection <= ~(rightOn);
	     xFlagBullet = (xCnt >= 6'd3);
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
