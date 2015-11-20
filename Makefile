
all: doc gui-tools

doc: FORCE
	cd docsrc/ && make -f Makefile

distrib: doc gui-tools-distrib FORCE
	cd distrib/ && make -f Makefile

clean:
	cd docsrc/ && make -f Makefile clean
	cd distrib/ && make -f Makefile clean
	cd gui-tools/ && make -f Makefile clean

lines: FORCE
	wc -l scripts/*.php scripts/*/*.php support/toolchain/*/*.php distrib/*.php gui-tools/src/*/*.h gui-tools/src/*/*.cpp gui-tools/src/*/*/*.h gui-tools/src/*/*/*.cpp | sort -n -k1

gui-tools: FORCE
	cd gui-tools/ && make -f Makefile

install: gui-tools

gui-tools-distrib: FORCE
	cd gui-tools/ && make -f Makefile distrib

FORCE:

