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
	rm -rf obj_dir/ debounce/ debounce_tb debounce.vcd
