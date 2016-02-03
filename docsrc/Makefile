SRC= $(wildcard ../scripts/*.php) $(wildcard ../scripts/*/*.php) $(wildcard ../support/toolchain/)

all: manual gpnode gplib tutorial doc-backend gpproc gpdevice

doc:
	mkdir -p ../doc/
	
clean: gpnode-clean tutorial-clean manual-clean doc-backend-clean
	rm -rf ../doc

doc-backend: ../doc/backend.pdf

../doc/backend.pdf: $(SRC)
	mkdir -p ../doc/backend
	cd ../scripts && doxygen > /dev/null
	cd ../doc/backend/latex/ && make -f Makefile > /dev/null
	cp ../doc/backend/latex/refman.pdf ../doc/backend.pdf
doc-backend-clean:
	cd ../doc || rm -rf backend

manual: doc FORCE
	cd manual/ && make -f Makefile
manual-clean: FORCE
	cd manual/ && make clean -f Makefile

gpnode: doc FORCE
	cd gpnode/ && make -f Makefile
gpnode-clean: FORCE
	cd gpnode/ && make clean -f Makefile

gpproc: doc FORCE
	cd gpproc/ && make -f Makefile
gpproc-clean: FORCE
	cd gpproc/ && make clean -f Makefile

gpdevice: doc FORCE
	cd gpdevice/ && make -f Makefile
gpdevice-clean: FORCE
	cd gpdevice/ && make clean -f Makefile

gplib: doc FORCE
	cd gplib/ && make -f Makefile
gplib-clean: FORCE
	cd gplib/ && make clean -f Makefile

tutorial: doc FORCE
	cd tutorial/ && make -f Makefile
tutorial-clean: FORCE
	cd tutorial/ && make clean -f Makefile

FORCE:

