`default_nettype none

// Module to sample a pushbutton value several times in succession.
// If the value stays constant over the number of samples, this
// value is output as the debounced button's value.
// (c) 2018 Warren Toomey, GPL3
//
module	debounce(i_clk, i_btn, o_debbtn);

  parameter	CLOCK_RATE_HZ = 16_000_000; // 16MHz clock
  parameter	SLOW_RATE_HZ  =  1_000_000; // 1uS clock, for simulation

  input i_clk;				    // System clock
  input i_btn;				    // Raw button value
  output reg o_debbtn=0;		    // Debounced button value

  // The last value of the button, and a counter
  reg last_btn=0;
  reg [23:0] counter=0;

  always @(posedge i_clk) begin
    // Reset the counter when the current & last
    // button states are different, otherwise
    // increment the counter
    if (i_btn != last_btn)
      counter <= 0;
    else begin
      counter <= counter + 1;

      // If we reach the threshold, output the button's value
      // and reset the counter so that it will never overflow
      if (counter == CLOCK_RATE_HZ/SLOW_RATE_HZ) begin
	o_debbtn <= i_btn;
        counter <= 0;
      end
    end

    // Save the button's value for the next clock tick
    last_btn <= i_btn;
  end

`ifdef FORMAL
  reg     f_past_valid;
  initial f_past_valid = 0;
  always @(posedge i_clk)
    f_past_valid <= f_past_valid + 1;

  // Design properties
  
  // The counter is bounded by the value CLOCK_RATE_HZ/SLOW_RATE_HZ
    always @(*)
      assert(counter <= CLOCK_RATE_HZ/SLOW_RATE_HZ);

  // A button change resets the counter. We need two
  // past values here as the counter will be zero on
  // the clock tick after the button value differs.
  always @(posedge i_clk)
    if ((f_past_valid >= 2) && ($past(i_btn) != $past(i_btn,2)))
      assert(counter == 0);

  // The counter is either zero or one more than the last value
  always @(posedge i_clk)
    if (f_past_valid >= 1)
      assert(counter == 0 || (counter == 1 + $past(counter)));

  // The debounced value can only change when we reach the upper
  // bound on the counter
  always @(posedge i_clk)
    if (f_past_valid >= 1)
      if (o_debbtn != $past(o_debbtn))
        assert($past(counter) == CLOCK_RATE_HZ/SLOW_RATE_HZ);
`endif

endmodule
