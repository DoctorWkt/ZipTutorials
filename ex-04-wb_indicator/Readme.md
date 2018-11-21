# wb_indicator

This is a modification of the ex-04-reqwalker project. In this version,
writing to address zero on the wishbone bus causes the LEDs to walk in
one direction. Writing to address one causes the LEDs to walk in the
other direction.

I've removed all the assumes to force the prover to try all initial
states. I've run out of ideas for more asserts, but if you see any
other ones let me know.
