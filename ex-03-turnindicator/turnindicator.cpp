////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	turnindicator.cpp
//
// Project:	Verilog Tutorial Example file
//
// Purpose:	This is an example Verilator test bench driver for
//		the turnindicator module.
//
// Creator:	Warren Toomey
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
#include <stdio.h>
#include <stdlib.h>
#include "Vturnindicator.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

void	tick(int tickcount, Vturnindicator *tb, VerilatedVcdC* tfp) {
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

// Print out the LEDs visually
void printleds(int k, int led)
{
	printf("k = %2d, ", k);
	printf("led = %02x:", led);
	for(int j=0; j<8; j++) {
		if(led & (1<<j))
			printf("O");
		else
			printf("-");
	}
        printf("\n");
}

int main(int argc, char **argv) {
	unsigned tickcount = 0;

	// Call commandArgs first!
	Verilated::commandArgs(argc, argv);

	// Instantiate our design
	Vturnindicator *tb = new Vturnindicator;

	// Generate a trace
	Verilated::traceEverOn(true);
	VerilatedVcdC* tfp = new VerilatedVcdC;
	tb->trace(tfp, 99);
	tfp->open("turnindicator.vcd");

	// Strobe the left button
	tb->i_left_stb= 1;
	for(int k=0; k<9; k++) {
		tick(++tickcount, tb, tfp);
		tb->i_left_stb= 0;
		printleds(k, tb->o_led);
	}

	// Strobe the right button
	tb->i_right_stb= 1;
	for(int k=0; k<9; k++) {
		tick(++tickcount, tb, tfp);
		tb->i_right_stb= 0;
		printleds(k, tb->o_led);
	}

	// Strobe the left button and strobe right
	// while we are walking
	tb->i_left_stb= 1;
	for(int k=0; k<8; k++) {
		tick(++tickcount, tb, tfp);
		tb->i_left_stb= 0;
		if (k==2) tb->i_right_stb= 1;
		if (k==3) tb->i_right_stb= 0;
		printleds(k, tb->o_led);
	}

	// Strobe the right button and strobe left
	// while we are walking
	tb->i_right_stb= 1;
	for(int k=0; k<10; k++) {
		tick(++tickcount, tb, tfp);
		tb->i_right_stb= 0;
		if (k==3) tb->i_left_stb= 1;
		if (k==4) tb->i_left_stb= 0;
		printleds(k, tb->o_led);
	}

	// Strobe the left button and strobe left
	// while we are walking
	tb->i_left_stb= 1;
	for(int k=0; k<10; k++) {
		tick(++tickcount, tb, tfp);
		tb->i_left_stb= 0;
		if (k==2) tb->i_left_stb= 1;
		if (k==3) tb->i_left_stb= 0;
		printleds(k, tb->o_led);
	}

	// Strobe the right button and strobe right
	// while we are walking
	tb->i_right_stb= 1;
	for(int k=0; k<10; k++) {
		tick(++tickcount, tb, tfp);
		tb->i_right_stb= 0;
		if (k==3) tb->i_right_stb= 1;
		if (k==4) tb->i_right_stb= 0;
		printleds(k, tb->o_led);
	}
}
