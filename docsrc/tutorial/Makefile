
all: install_linux quick_start_cmd
	
clean: install_linux-clean quick_start_cmd-clean

install_linux: FORCE
	cd install_linux/ && make -f Makefile
install_linux-clean: FORCE
	cd install_linux/ && make clean -f Makefile

quick_start_cmd: FORCE
	cd quick_start_cmd/ && make -f Makefile
quick_start_cmd-clean: FORCE
	cd quick_start_cmd/ && make clean -f Makefile

FORCE:

