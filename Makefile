
all: doc gui-tools

doc: docip FORCE
	cd docsrc/ && make -f Makefile

docip: FORCE
	cd support/ && make -f Makefile

distrib: doc FORCE
	cd distrib/ && make -f Makefile

distrib-web: distrib
	cp doc/*.pdf /var/www/gpstudio/doc
	cp distrib/gpstudio_linux32-qt4-`cat version.txt`.tar.gz /var/www/gpstudio/download/distrib/
	cp distrib/gpstudio_linux64-qt4-`cat version.txt`.tar.gz /var/www/gpstudio/download/distrib/
	cp distrib/gpstudio_linux32-qt5-`cat version.txt`.tar.gz /var/www/gpstudio/download/distrib/
	cp distrib/gpstudio_linux64-qt5-`cat version.txt`.tar.gz /var/www/gpstudio/download/distrib/
	cp distrib/gpstudio_win64-qt5-`cat version.txt`.zip /var/www/gpstudio/download/distrib/
	cp distrib/setup-gpstudio_win64-qt5-`cat version.txt`.exe /var/www/gpstudio/download/distrib/

clean:
	cd docsrc/ && make -f Makefile clean
	cd distrib/ && make -f Makefile clean
	cd gui-tools/ && make -f Makefile clean

lines: FORCE
	wc -l scripts/*.php scripts/*/*.php support/toolchain/*/*.php distrib/*.php gui-tools/src/*/*.h gui-tools/src/*/*.cpp gui-tools/src/*/*/*.h gui-tools/src/*/*/*.cpp gui-tools/src/*/*/*/*.h gui-tools/src/*/*/*/*.cpp *_completion| sort -n -k1

gui-tools: FORCE
	cd gui-tools/ && make -f Makefile

install: gui-tools

checklib:
	bin/gplib checklib

FORCE:

