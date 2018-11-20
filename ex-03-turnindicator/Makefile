################################################################################
##
## Filename: 	Makefile
##
## Project:	Verilog Tutorial Example file
##
## Purpose:	Builds the Verilator turn indicator example
##
## Targets:
##
##	The (default) or all target will build a verilator simulation for the
##	turn indicator
##
##	clean	Removes all build products
##
##	prove	Runs a formal verification on the module
##
## Creator:	Warren Toomey
##
################################################################################
##
## Written and distributed by Warren Toomey
##
## This program is hereby granted to the public domain.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or
## FITNESS FOR A PARTICULAR PURPOSE.
##
################################################################################
##
##


.PHONY: all
all: turnindicator_tb

VERILATOR=verilator
VERILATOR_ROOT ?= $(shell bash -c 'verilator -V|grep VERILATOR_ROOT | head -1 | sed -e "s/^.*=\s*//"')
VINC := $(VERILATOR_ROOT)/include

obj_dir/Vturnindicator.cpp: turnindicator.v
	$(VERILATOR) --trace -Wall -cc turnindicator.v

obj_dir/Vturnindicator__ALL.a: obj_dir/Vturnindicator.cpp
	make --no-print-directory -C obj_dir -f Vturnindicator.mk

turnindicator_tb: turnindicator.cpp obj_dir/Vturnindicator__ALL.a
	g++ -I$(VINC) -I obj_dir $(VINC)/verilated.cpp		\
		$(VINC)/verilated_vcd_c.cpp turnindicator.cpp	\
		obj_dir/Vturnindicator__ALL.a -o turnindicator_tb

.PHONY: prove
prove:
	sby -f formaltest.sby

## The following are rules to make the TinyFPGA bitstream
PROJ = TinyFPGA_B
PIN_DEF = pins.pcf
DEVICE = lp8k

.PHONY: stream
stream: $(PROJ).rpt $(PROJ).bin

%.blif: %.v
	yosys -p 'synth_ice40 -top $(PROJ) -blif $@' $<

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d 8k -P cm81 -o $@ -p $^

%.bin: %.asc
	icepack $< $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

.PHONY: prog
prog: $(PROJ).bin
	tinyfpgab --program $<

.PHONY: clean
clean:
	rm -rf obj_dir/ turnindicator/ formaltest/ \
		turnindicator_tb turnindicator.vcd
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).rpt $(PROJ).bin
