#include <stdio.h>
#include <stdlib.h>
#include "Vdebounce.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

void	tick(int tickcount, Vdebounce *tb, VerilatedVcdC* tfp) {
	tb->eval();
	if (tfp)
		tfp->dump(tickcount * 10 - 2);
	tb->i_clk = 1;
	tb->eval();
	if (tfp)
		tfp->dump(tickcount * 10);
	tb->i_clk = 0;
	tb->eval();
	if (tfp) {
		tfp->dump(tickcount * 10 + 5);
		tfp->flush();
	}
}

int main(int argc, char **argv) {
	unsigned tickcount = 0;

	// Call commandArgs first!
	Verilated::commandArgs(argc, argv);

	// Instantiate our design
	Vdebounce *tb = new Vdebounce;

	// Generate a trace
	Verilated::traceEverOn(true);
	VerilatedVcdC* tfp = new VerilatedVcdC;
	tb->trace(tfp, 99);
	tfp->open("debounce.vcd");

	tb->i_btn=0;
	for(int k=0; k<(1<<10); k++) {
		tick(++tickcount, tb, tfp);

		// Turn on the button for 20 ticks
		if (tickcount > 20) tb->i_btn=1;
		if (tickcount > 40) tb->i_btn=0;

		// Turn it on for under 16 ticks
		if (tickcount > 50) tb->i_btn=1;
		if (tickcount > 60) tb->i_btn=0;

		if (tickcount > 200) tb->i_btn=1;
		if (tickcount > 225) tb->i_btn=0;

		if (tickcount > 340) tb->i_btn=1;
		if (tickcount > 345) tb->i_btn=0;

		if (tickcount > 400) tb->i_btn=1;
		if (tickcount > 450) tb->i_btn=0;
	}
}
