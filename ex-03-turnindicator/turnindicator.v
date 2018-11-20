////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	turnindicator.v
//
// Project:	Verilog Tutorial Example file
//
// Purpose:	To walk an active LED back and forth across a set of 8 LEDs,
//		acting as a turn indicator on a vehicle.
//
// Creator:	Warren Toomey
//
// Function:	The module has inputs a clock, a left push button and a right
//		push button. Its outputs are eight LED signals. Initially,
//		all LEDs are off. When the left	button is strobed, one LED
//		walks from right to left (LSB to MSB) and then all LEDs go
//		off and stay off. When the right button is strobed, one LED
//		walks from left to right (MSB to LSB) and then all LEDs go
//		off and stay off.
//
//		The question is, what happens when the buttons strobe
//		during the walking? If a different button is pressed
//		than the one that started the LEDs walking, the direction
//		changes. All other button presses are ignored.
//
////////////////////////////////////////////////////////////////////////////////
//
// Written and distributed by Warren Toomey
//
// This program is hereby granted to the public domain.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or
// FITNESS FOR A PARTICULAR PURPOSE.
//
////////////////////////////////////////////////////////////////////////////////
//
//
`default_nettype none
module	turnindicator(i_clk, i_left_stb, i_right_stb, o_led);
  input	wire		i_clk;
  input	wire		i_left_stb;
  input	wire		i_right_stb;
  output reg	[7:0]	o_led;

  // State names
  parameter IDLE = 		0;
  parameter MOVING_RIGHT =	1;
  parameter MOVING_LEFT = 	2;

  // State variable
  reg [1:0] state;

  initial o_led = 0;
  initial state = IDLE;

  always @(posedge i_clk) begin

`ifdef FORMAL
    // Formal testing. If we are idle, the LEDs must all be off.
    // If we are not idle, at least one LED must be on.
    assert((state==IDLE) == (o_led==0));

    // Only zero or one LED can be on at any time
    assert((o_led==8'h0)  || (o_led==8'h1)  || (o_led==8'h2)  ||
	   (o_led==8'h4)  || (o_led==8'h8)  || (o_led==8'h10) ||
	   (o_led==8'h20) || (o_led==8'h40) || (o_led==8'h80));
`endif

    case (state)
      IDLE: begin
	      // Left button was strobed
	      if (i_left_stb && !i_right_stb) begin
		state <= MOVING_LEFT;
		o_led <= 8'b0000_0001;
	      end

	      // Right button was strobed
	      if (i_right_stb && !i_left_stb) begin
		state <= MOVING_RIGHT;
		o_led <= 8'b1000_0000;
	      end

	      // Stay idle if both or neither buttons pressed
	    end

      MOVING_RIGHT: begin
	      // Walk one LED to the right
	      o_led <= o_led >> 1;

	      // Change direction if left button only pressed
	      if (i_left_stb && !i_right_stb)
		state <= MOVING_LEFT;

	      // We've walked to the other end, go to idle
	      if (o_led == 8'b0000_0001) begin
		state <= IDLE;
		o_led <= 0;
	      end
	    end

      MOVING_LEFT: begin
	      // Walk one LED to the left
	      o_led <= o_led << 1;

	      // Change direction if right button only pressed
	      if (i_right_stb && !i_left_stb)
		state <= MOVING_RIGHT;

	      // We've walked to the other end, go to idle
	      if (o_led == 8'b1000_0000) begin
		state <= IDLE;
		o_led <= 0;
	      end
	    end

`ifdef FORMAL
      default:
	    assert(0);		// We must never be in any other state
`endif
    endcase
  end
endmodule
