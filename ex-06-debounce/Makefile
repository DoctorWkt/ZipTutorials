.PHONY: all
all: debounce_tb

VERILATOR=verilator
VERILATOR_ROOT ?= $(shell bash -c 'verilator -V|grep VERILATOR_ROOT | head -1 | sed -e "s/^.*=\s*//"')
VINC := $(VERILATOR_ROOT)/include

obj_dir/Vdebounce.cpp: debounce.v
	$(VERILATOR) --trace -Wall -cc debounce.v

obj_dir/Vdebounce__ALL.a: obj_dir/Vdebounce.cpp
	make --no-print-directory -C obj_dir -f Vdebounce.mk

debounce_tb: debounce.cpp obj_dir/Vdebounce__ALL.a
	g++ -I$(VINC) -I obj_dir $(VINC)/verilated.cpp		\
		$(VINC)/verilated_vcd_c.cpp debounce.cpp	\
		obj_dir/Vdebounce__ALL.a -o debounce_tb

.PHONY: clean
clean:
	rm -rf obj_dir/ debounce/ debounce_tb debounce.vcd \
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).rpt $(PROJ).bin


## The following are rules to make the TinyFPGA bitstream
PROJ = TinyFPGA_B
PIN_DEF = pins.pcf
DEVICE = lp8k

.PHONY: bin
bin: $(PROJ).rpt $(PROJ).bin

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

.PHONY: prove
prove:
	sby -f debounce.sby
