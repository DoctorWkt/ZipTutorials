`default_nettype none
module  wb_indicator(i_clk, i_cyc, i_stb, i_we, i_addr, i_data,
                     o_stall, o_ack, o_data, o_led);
  input   wire            i_clk;
        
  // Our wishbone bus interface
  input   wire            i_cyc, i_stb, i_we;
  input   wire            i_addr;
  input   wire    [31:0]  i_data;
  output  wire            o_stall;
  output  reg             o_ack;
  output  wire    [31:0]  o_data;

  // Output to LEDs
  output  reg      [7:0]  o_led;

  // Verilator lint_off UNUSED
  wire    [33:0]  unused;
  assign  unused = { i_cyc, i_addr, i_data };
  // Verilator lint_on  UNUSED

  // State names
  parameter IDLE = 	   2'd0;
  parameter MOVING_RIGHT = 2'd1;
  parameter MOVING_LEFT =  2'd2;

  // State variable
  reg [1:0] state;

  // Initial state
  initial o_led = 0;
  initial state = IDLE;
  initial o_ack = 1'b0;

  // Stall write requests when we are not idle
  assign  o_stall = (state != IDLE) && (i_we);

  // Always set the output data to the LED state
  assign  o_data = { 24'h0, o_led };

  // Acknowledge a strobe when not stalled
  always @(posedge i_clk)
    o_ack <= (i_stb) && (!o_stall);

  // State machine. Deal with the three states
  always @(posedge i_clk)
    case (state)

      // Deal with a wishbone write request
      IDLE: begin
        if ((i_stb) && (i_we) && (!o_stall)) begin

      	  // Address 0 is left-button
      	  // Address 1 is right-button
      	  if (i_addr == 0) begin
	    state <= MOVING_LEFT;
	    o_led <= 8'b0000_0001;
      	  end else begin
	    state <= MOVING_RIGHT;
            o_led <= 8'b1000_0000;
      	  end
        end
      end

      // Walk the LED when we are in a moving state
      MOVING_RIGHT: begin
        // Walk one LED to the right
        o_led <= o_led >> 1;

        // We've walked to the other end, go to idle
        if (o_led == 8'b0000_0001) begin
          state <= IDLE;
          o_led <= 0;
        end
      end

      // Walk the LED when we are in a moving state
      MOVING_LEFT: begin
        // Walk one LED to the left
        o_led <= o_led << 1;

        // We've walked to the other end, go to idle
        if (o_led == 8'b1000_0000) begin
          state <= IDLE;
          o_led <= 0;
        end
      end

      default: assert(0);	// Must not get into this state
    endcase

`ifdef	FORMAL
    reg	f_past_valid;
    initial f_past_valid = 0;
    always @(posedge i_clk)
      f_past_valid <= 1'b1;

    // Bus properties
    // ==============
    // We must acknowledge a strobe when we are not stalled
    always @(posedge i_clk)
      if ((f_past_valid) && ($past(i_stb)) && (!$past(o_stall)))
	assert(o_ack);

    // We must assert o_stall when not idle and there is a write request
    always @(*)
      if ((state != IDLE) && (i_we))
        assert(o_stall);

    // Design properties
    // =================
    // The state must be IDLE, MOVING_LEFT or MOVING_RIGHT
    always @(*)
      assert(state == IDLE || state == MOVING_LEFT || state == MOVING_RIGHT);

    // The LEDs must be off in the IDLE state
    always @(posedge i_clk)
      if (state == IDLE)
        assert(o_led == 0);

    // The LEDs must not all be off when not IDLE
    always @(posedge i_clk)
      if (state != IDLE)
        assert(o_led != 0);

    // We must move from IDLE to MOVING_LEFT on these conditions
    always @(posedge i_clk)
      if (f_past_valid && $past(i_stb) && $past(i_we)
	&& $past(!o_stall) && $past(i_addr) == 0
	&& $past(state) == IDLE)
          assert(state == MOVING_LEFT);

    // We must move from IDLE to MOVING_RIGHT on these conditions
    always @(posedge i_clk)
      if (f_past_valid && $past(i_stb) && $past(i_we)
	&& $past(!o_stall) && $past(i_addr) == 1
	&& $past(state) == IDLE)
          assert(state == MOVING_RIGHT);
`endif

endmodule
