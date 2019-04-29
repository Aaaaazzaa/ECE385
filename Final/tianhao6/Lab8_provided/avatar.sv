module avatar(  input Clk,
                      Reset,
                      frame_clk,
                input [7:0] keycode,
                input [9:0] DrawX, DrawY, sky, ground,
                output logic is_avatar
                );
  //  xcor <= xcorIn
  //  xcorIn = xcorprev + dx
  //  const dx

  //  ycor <= ycorIn
  //  ycorIn = ycorprev + dy
  //  const dy

  parameter [9:0] xcenter = 10'd320;  // Center position on the X axis
  parameter [9:0] ycenter = 10'd240;  // Center position on the Y axis
  parameter [9:0] xcormin = 10'd0;       // Leftmost point on the X axis
  parameter [9:0] xcormax = 10'd639;     //Rightmost point on the X axis
  parameter [9:0] constv = 10'd3;

  parameter [9:0] size = 10'd4;        // Ball size
  // cumstom parameter
  parameter [9:0] gravity = 10'd2;

  logic [9:0] xcor, ycor; // implied register
  logic [9:0] xcorprev, ycorprev, vyprev, dx, dy, ycorIn, xcorIn; // tmp
  // given
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
          xcor <= xcenter;
          ycor <= ycenter;
      end
      else
        begin
          xcor <= xcorIn;
          ycor <= ycorIn;
        end
  end
  //////// Do not modify the always_ff blocks. ////////

  // You need to modify always_comb block.
  always_comb
  begin
      // By default, keep motion and position unchanged
      xcorIn = xcor;
      ycorIn = ycor;

      // Update position and motion only at rising edge of frame clock
      if (frame_clk_rising_edge)
      begin
      unique case(keycode[7:0])
        8'h4f:// ->
          begin
              xcorIn = xcorprev + constv;
          end
        8'h50:// <-
          begin
              ycorIn = ycorprev + (~constv + 10'd1);
          end
        // 8'h16://s
        //   begin
        //     Ball_X_Motion_in=10'd0;
        //     Ball_Y_Motion_in=10'd1;
        //   end
        // 8'h07://d
        //   begin
        //     Ball_Y_Motion_in=10'd0;
        //     Ball_X_Motion_in=10'd1;
        //   end
        default: ;
      endcase
          // Be careful when using comparators with "logic" datatype because compiler treats
          //   both sides of the operator as UNSIGNED numbers.
          // e.g. ycor - size <= sky
          // If ycor is 0, then ycor - size will not be -4, but rather a large positive number.
          if( ycor + size >= ground )  // Ball is at the bottom edge, BOUNCE!
              ycorIn = ycor;
          else if ( ycor <= sky + size )  // Ball is at the top edge, BOUNCE!
              ycorIn = ycor;

          // TODO: Add other boundary detections and handle keypress here.
      else if ( xcor + size >= xcormax )
         xcorIn = xcor;
      else if ( xcor <= xcormin + size )
         xcorIn = xcor;
      end
  end

  // Compute whether the pixel corresponds to ball or background
  /* Since the multiplicants are required to be signed, we have to first cast them
     from logic to int (signed by default) before they are multiplied. */
  int DistX, DistY, Size;
  assign DistX = DrawX - xcor;
  assign DistY = DrawY - ycor;
  assign Size = size;
  always_comb begin
      if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) )
          is_avatar = 1'b1;
      else
          is_avatar = 1'b0;
      /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while
         the single line is quite powerful descriptively, it causes the synthesis tool to use up three
         of the 12 available multipliers on the chip! */
  end
endmodule
