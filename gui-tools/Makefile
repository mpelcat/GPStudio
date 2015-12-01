
all: gui-tools

gui-tools: gpnode gpviewer

distrib: gpnode-win gpviewer-win gpnode-linux gpviewer-linux


build-win/:
	mkdir build-win
build-win/Makefile: build-win/ src/gpstudio.pro
	cd build-win/ && /opt/qt-5.5-win32/bin/qmake -r ../src "DISTRIB=1"
gpstudio_com-win: build-win/Makefile
	cd build-win/ && make -j9 -f Makefile sub-gpstudio_com-release
gpstudio_lib-win: build-win/Makefile gpstudio_com-win
	cd build-win/ && make -j9 -f Makefile sub-gpstudio_lib-release
gpstudio_gui-win: build-win/Makefile gpstudio_com-win gpstudio_lib-win
	cd build-win/ && make -j9 -f Makefile sub-gpstudio_gui-release
gpnode-win: build-win/Makefile gpstudio_com-win gpstudio_lib-win gpstudio_gui-win
	cd build-win/ && make -j9 -f Makefile sub-gpnode-release
gpviewer-win: build-win/Makefile gpstudio_com-win gpstudio_lib-win gpstudio_gui-win
	cd build-win/ && make -j9 -f Makefile sub-gpviewer-release


build-linux/:
	mkdir build-linux
build-linux/Makefile: build-linux/ src/gpstudio.pro
	cd build-linux/ && qmake -r ../src "DISTRIB=1" -spec linux-g++-64
gpstudio_com-linux: build-linux/Makefile
	cd build-linux/ && make -j9 -f Makefile sub-gpstudio_com
gpstudio_lib-linux: build-linux/Makefile gpstudio_com-linux
	cd build-linux/ && make -j9 -f Makefile sub-gpstudio_lib
gpstudio_gui-linux: build-linux/Makefile gpstudio_com-linux gpstudio_lib-linux
	cd build-linux/ && make -j9 -f Makefile sub-gpstudio_gui
gpnode-linux: build-linux/Makefile gpstudio_com-linux gpstudio_lib-linux gpstudio_gui-linux
	cd build-linux/ && make -j9 -f Makefile sub-gpnode
gpviewer-linux: build-linux/Makefile gpstudio_com-linux gpstudio_lib-linux gpstudio_gui-linux
	cd build-linux/ && make -j9 -f Makefile sub-gpviewer


build/:
	mkdir build
build/Makefile: build/ src/gpstudio.pro
	cd build/ && qmake ../src -spec linux-g++-64
gpstudio_com: build/Makefile
	cd build/ && make -j9 -f Makefile sub-gpstudio_com
gpstudio_lib: build/Makefile gpstudio_com
	cd build/ && make -j9 -f Makefile sub-gpstudio_lib
gpstudio_gui: build/Makefile gpstudio_com gpstudio_lib
	cd build/ && make -j9 -f Makefile sub-gpstudio_gui
gpnode: build/Makefile gpstudio_com gpstudio_lib gpstudio_gui
	cd build/ && make -j9 -f Makefile sub-gpnode
gpviewer: build/Makefile gpstudio_com gpstudio_lib gpstudio_gui
	cd build/ && make -j9 -f Makefile sub-gpviewer


clean:
	rm -rf build/
	rm -rf build-linux/
	rm -rf build-win/


FORCE:

