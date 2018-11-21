################################################################################
##
## Filename: 	Makefile
##
## Project:	Verilog Tutorial Example file
##
## Purpose:	Builds the Verilator turn indicator bus slave example
##
## Targets:
##
##	The (default) or all target will build a verilator simulation for the
##	turn indicator bus slave.
##
##	clean	Removes all build products
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
all: wb_indicator_tb

VERILATOR=verilator
VERILATOR_ROOT ?= $(shell bash -c 'verilator -V|grep VERILATOR_ROOT | head -1 | sed -e "s/^.*=\s*//"')
VINC := $(VERILATOR_ROOT)/include

obj_dir/Vwb_indicator.cpp: wb_indicator.v
	$(VERILATOR) --trace -Wall -cc wb_indicator.v

obj_dir/Vwb_indicator__ALL.a: obj_dir/Vwb_indicator.cpp
	make --no-print-directory -C obj_dir -f Vwb_indicator.mk

wb_indicator_tb: wb_indicator.cpp obj_dir/Vwb_indicator__ALL.a
	g++ -I$(VINC) -I obj_dir $(VINC)/verilated.cpp	\
		$(VINC)/verilated_vcd_c.cpp wb_indicator.cpp	\
		obj_dir/Vwb_indicator__ALL.a -o wb_indicator_tb

.PHONY: run
run: wb_indicator_tb
	./wb_indicator_tb

.PHONY: cvr
cvr:
	sby -f wb_indicator.sby cvr

.PHONY: prf
prf:
	sby -f wb_indicator.sby prf

.PHONY: clean
clean:
	rm -rf obj_dir/ wb_indicator wb_indicator.vcd \
		wb_indicator_cvr wb_indicator_prf wb_indicator_tb
