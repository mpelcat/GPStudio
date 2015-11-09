
all: doc

doc: FORCE
	cd docsrc/ && make -f Makefile

distrib: doc FORCE
	cd distrib/ && make -f Makefile

clean:
	cd docsrc/ && make clean -f Makefile
	cd distrib/ && make clean -f Makefile

lines: FORCE
	wc -l scripts/*.php scripts/*/*.php support/toolchain/*/*.php | sort -n -k1

gui-tools: FORCE
	cd gui-tools/ && make -f Makefile

install:
	cd gui-tools/ && make -f Makefile install

FORCE:

