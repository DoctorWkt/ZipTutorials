// Top-Level Verilog Module for TinyFPGA B2.
// Only include the pins that the design is actually using.  Make sure that
// the pin is given the correct direction: input vs. output vs. inout

`include "wkt_blinky.v"

module TinyFPGA_B (
  //output pin1_usb_dp,
  //inout pin2_usb_dn,
  input pin3_clk_16mhz,
  //output pin4,
  //output pin5,
  output pin6,
  output pin7,
  output pin8,
  output pin9,
  output pin10,
  output pin11,
  output pin12,
  output pin13,
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
  //inout pin24
);

  // Connect eight LEDs to pins 6 to 13
  wire [7:0]     o_led;
  assign pin6 =  o_led[7];
  assign pin7 =  o_led[6];
  assign pin8 =  o_led[5];
  assign pin9 =  o_led[4];
  assign pin10 = o_led[3];
  assign pin11 = o_led[2];
  assign pin12 = o_led[1];
  assign pin13 = o_led[0];

  // Attach the blinky module to the clock and the LED pins
  wkt_blinky dut(.i_clk(pin3_clk_16mhz), .o_led(o_led));
endmodule
