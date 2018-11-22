////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	helloworld_tb.cpp
//
// Project:	Verilog Tutorial Example file
//
// Purpose:	To demonstrate a Verilog main() program that calls a local
//		serial port co-simulator.
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
//
// Written and distributed by Gisselquist Technology, LLC
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
#include <verilatedos.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <time.h>
#include <sys/types.h>
#include <signal.h>
#include "verilated.h"
#include "Vhelloworld.h"
#include "testb.h"
#include "uartsim.h"

int	main(int argc, char **argv) {
	Verilated::commandArgs(argc, argv);
	TESTB<Vhelloworld>	*tb
		= new TESTB<Vhelloworld>;
	UARTSIM		*uart;
	unsigned	baudclocks;


	uart = new UARTSIM();
	baudclocks = tb->m_core->o_setup;
	uart->setup(baudclocks);

	tb->opentrace("helloworld.vcd");

	for(unsigned clocks=0;
		clocks < 16*12*baudclocks;
		 clocks++) {

		tb->tick();
		(*uart)(tb->m_core->o_uart_tx);
	}

	printf("\n\nSimulation complete\n");
}
