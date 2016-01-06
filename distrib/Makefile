GREEN=\033[0;32m
RED=\033[0;31m
NC=\033[0m

all: distrib

distrib: distrib-win64-qt5 distrib-linux32-qt4 distrib-linux64-qt4 distrib-linux32-qt5 distrib-linux64-qt5

gui-tools-win64-qt5: FORCE
	cd ../gui-tools/ && make -f Makefile gui-tools-win64-qt5 > /dev/null
distrib-win64-qt5: gui-tools-win64-qt5
	@echo "${GREEN}GPStudio win64-qt5${NC}"
	rm -rf gpstudio_win64-qt5
	php distrib.php -s win -a 64 -q 5 -o gpstudio_win64-qt5
	zip -r gpstudio_win64-qt5-`cat ../version.txt`.zip gpstudio_win64-qt5/ > /dev/null

gui-tools-linux32-qt4: FORCE
	cd ../gui-tools/ && make -f Makefile gui-tools-linux32-qt4 > /dev/null
distrib-linux32-qt4: gui-tools-linux32-qt4
	@echo "${GREEN}GPStudio linux32-qt4${NC}"
	rm -rf gpstudio_linux32-qt4
	php distrib.php -s linux -a 32 -q 4 -o gpstudio_linux32-qt4
	tar zcf gpstudio_linux32-qt4-`cat ../version.txt`.tar.gz gpstudio_linux32-qt4/

gui-tools-linux64-qt4: FORCE
	cd ../gui-tools/ && make -f Makefile gui-tools-linux64-qt4 > /dev/null
distrib-linux64-qt4: gui-tools-linux64-qt4
	@echo "${GREEN}GPStudio linux64-qt4${NC}"
	rm -rf gpstudio_linux64-qt4
	php distrib.php -s linux -a 64 -q 4 -o gpstudio_linux64-qt4
	tar zcf gpstudio_linux64-qt4-`cat ../version.txt`.tar.gz gpstudio_linux64-qt4/

gui-tools-linux32-qt5: FORCE
	cd ../gui-tools/ && make -f Makefile gui-tools-linux32-qt5 > /dev/null
distrib-linux32-qt5: gui-tools-linux32-qt5
	@echo "${GREEN}GPStudio linux32-qt5${NC}"
	rm -rf gpstudio_linux32-qt5
	php distrib.php -s linux -a 32 -q 5 -o gpstudio_linux32-qt5
	tar zcf gpstudio_linux32-qt5-`cat ../version.txt`.tar.gz gpstudio_linux32-qt5/

gui-tools-linux64-qt5: FORCE
	cd ../gui-tools/ && make -f Makefile gui-tools-linux64-qt5 > /dev/null
distrib-linux64-qt5: gui-tools-linux64-qt5
	@echo "${GREEN}GPStudio linux64-qt5${NC}"
	rm -rf gpstudio_linux64-qt5
	php distrib.php -s linux -a 64 -q 5 -o gpstudio_linux64-qt5
	tar zcf gpstudio_linux64-qt5-`cat ../version.txt`.tar.gz gpstudio_linux64-qt5/

clean: FORCE
	rm -rf gpstudio_win
	rm -rf gpstudio_linux
	rm -f gpstudio_win.zip
	rm -f gpstudio_linux.tar.gz

FORCE:
