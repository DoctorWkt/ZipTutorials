// Top-Level Verilog Module for TinyFPGA B2.
// Only include the pins that the design is actually using.  Make sure that
// the pin is given the correct direction: input vs. output vs. inout

`include "debounce.v"
`default_nettype none

module TinyFPGA_B (
  //output pin1_usb_dp,
  //inout pin2_usb_dn,
  input pin3_clk_16mhz,	// 16MHz clock
  //output pin4,
  //output pin5,
  output pin6,		// Seven unused LEDs: 6 to 12
  output pin7,
  output pin8,
  output pin9,
  output pin10,
  output pin11,
  output pin12,
  output pin13,		// Debounced output
  //inout pin14_sdo,
  //inout pin15_sdi,
  //inout pin16_sck,
  //inout pin17_ss,
  //inout pin18,
  //inout pin19,
  //inout pin20,
  //inout pin21,
  //inout pin22,
  //inout pin23,
  inout pin24		// Raw button
);

  // Set the other seven LEDs off
  assign pin6  = 0;
  assign pin7  = 0;
  assign pin8  = 0;
  assign pin9  = 0;
  assign pin10 = 0;
  assign pin11 = 0;
  assign pin12 = 0;

  debounce   #(16_000_000, 100)		// 1/100th of a second delay
	   dut(pin3_clk_16mhz, pin24, pin13);
endmodule
