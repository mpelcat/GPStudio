
all: distrib

distrib: distrib-win distrib-linux

distrib-win: clean FORCE
	rm -rf gpstudio_win
	php distrib.php -o win
	zip -r gpstudio_win-`cat ../version.txt`.zip gpstudio_win > /dev/null

distrib-linux: clean FORCE
	rm -rf gpstudio_linux
	php distrib.php -o linux
	tar zcf gpstudio_linux-`cat ../version.txt`.tar.gz gpstudio_linux/

clean:
	rm -rf gpstudio_win
	rm -rf gpstudio_linux
	rm -f gpstudio_win.zip
	rm -f gpstudio_linux.tar.gz

FORCE:

