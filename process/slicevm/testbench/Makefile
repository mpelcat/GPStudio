#       Makefile
#       
#       2013 acvin <luca@luca-lab>
#       

ALTERA_DIR = ~/altera/13.1/modelsim_ase/bin
LIBSIM = -L ~/altera/13.1/modelsim_ase/altera/verilog/altera_mf/ -L ~/altera/13.1/modelsim_ase/altera/verilog/220model/
 

# compiling the source file.
%: %.v
	$(ALTERA_DIR)/vlib work
	$(ALTERA_DIR)/vlog $@.v ../src_dev/*.v && $(ALTERA_DIR)/vsim -c $(LIBSIM) -do 'run 200us;quit' $@ 
	
