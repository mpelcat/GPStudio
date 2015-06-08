
LIBSIM += $(HOME)/altera/13.1/modelsim_ase/altera/verilog/src/altera_mf.v
LIBCOF = $(HOME)/svn_lab/rtn/common/library/fpga/CameraOneFrame/ 

COFSRCS = $(shell find $(LIBCOF) -name '*.v')
SRCDIR = ../../src


SRCS := $(shell find $(SRCDIR) -name '*.v')

# compiling the source file.
%: %.v
	iverilog $@.v $(SRCS) $(LIBSIM) -s $@ -o $@.o
	
