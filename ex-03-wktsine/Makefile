.PHONY: all
all: wkt_blinky_tb

VERILATOR=verilator
VERILATOR_ROOT ?= $(shell bash -c 'verilator -V|grep VERILATOR_ROOT | head -1 | sed -e "s/^.*=\s*//"')
VINC := $(VERILATOR_ROOT)/include

obj_dir/Vwkt_blinky.cpp: wkt_blinky.v
	$(VERILATOR) --trace -Wall -cc wkt_blinky.v

obj_dir/Vwkt_blinky__ALL.a: obj_dir/Vwkt_blinky.cpp
	make --no-print-directory -C obj_dir -f Vwkt_blinky.mk

wkt_blinky_tb: wkt_blinky.cpp obj_dir/Vwkt_blinky__ALL.a
	g++ -I$(VINC) -I obj_dir $(VINC)/verilated.cpp		\
		$(VINC)/verilated_vcd_c.cpp wkt_blinky.cpp	\
		obj_dir/Vwkt_blinky__ALL.a -o wkt_blinky_tb

.PHONY: clean
clean:
	rm -rf obj_dir/ wkt_blinky/ wkt_blinky_tb wkt_blinky.vcd
