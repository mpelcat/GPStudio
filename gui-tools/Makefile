
all: gui-tools

gui-tools: gpnode gpviewer

distrib: gui-tools-win64-qt5 gui-tools-linux32-qt4 gui-tools-linux64-qt4 gui-tools-linux32-qt5 gui-tools-linux64-qt5

gui-tools-win64-qt5: gpnode-win64-qt5 gpviewer-win64-qt5
build-win64-qt5/:
	mkdir build-win64-qt5
build-win64-qt5/Makefile: build-win64-qt5/ src/gpstudio.pro
	cd build-win64-qt5/ && /opt/qt-5.5-win32/bin/qmake -r ../src "DISTRIB=1"
gpstudio_com-win64-qt5: build-win64-qt5/Makefile
	cd build-win64-qt5/ && make -j9 -f Makefile sub-gpstudio_com-release
gpstudio_lib-win64-qt5: build-win64-qt5/Makefile gpstudio_com-win64-qt5
	cd build-win64-qt5/ && make -j9 -f Makefile sub-gpstudio_lib-release
gpstudio_gui-win64-qt5: build-win64-qt5/Makefile gpstudio_com-win64-qt5 gpstudio_lib-win64-qt5
	cd build-win64-qt5/ && make -j9 -f Makefile sub-gpstudio_gui-release
gpnode-win64-qt5: build-win64-qt5/Makefile gpstudio_com-win64-qt5 gpstudio_lib-win64-qt5 gpstudio_gui-win64-qt5
	cd build-win64-qt5/ && make -j9 -f Makefile sub-gpnode-release
gpviewer-win64-qt5: build-win64-qt5/Makefile gpstudio_com-win64-qt5 gpstudio_lib-win64-qt5 gpstudio_gui-win64-qt5
	cd build-win64-qt5/ && make -j9 -f Makefile sub-gpviewer-release


gui-tools-linux32-qt4: gpnode-linux32-qt4 gpviewer-linux32-qt4
build-linux32-qt4/:
	mkdir build-linux32-qt4
build-linux32-qt4/Makefile: build-linux32-qt4/ src/gpstudio.pro
	cd build-linux32-qt4/ && /opt/Qt4.8_32/bin/qmake -r ../src "DISTRIB=1" -spec linux-g++-32
gpstudio_com-linux32-qt4: build-linux32-qt4/Makefile
	cd build-linux32-qt4/ && make -j9 -f Makefile sub-gpstudio_com
gpstudio_lib-linux32-qt4: build-linux32-qt4/Makefile gpstudio_com-linux32-qt4
	cd build-linux32-qt4/ && make -j9 -f Makefile sub-gpstudio_lib
gpstudio_gui-linux32-qt4: build-linux32-qt4/Makefile gpstudio_com-linux32-qt4 gpstudio_lib-linux32-qt4
	cd build-linux32-qt4/ && make -j9 -f Makefile sub-gpstudio_gui
gpnode-linux32-qt4: build-linux32-qt4/Makefile gpstudio_com-linux32-qt4 gpstudio_lib-linux32-qt4 gpstudio_gui-linux32-qt4
	cd build-linux32-qt4/ && make -j9 -f Makefile sub-gpnode
gpviewer-linux32-qt4: build-linux32-qt4/Makefile gpstudio_com-linux32-qt4 gpstudio_lib-linux32-qt4 gpstudio_gui-linux32-qt4
	cd build-linux32-qt4/ && make -j9 -f Makefile sub-gpviewer


gui-tools-linux64-qt4: gpnode-linux64-qt4 gpviewer-linux64-qt4
build-linux64-qt4/:
	mkdir build-linux64-qt4
build-linux64-qt4/Makefile: build-linux64-qt4/ src/gpstudio.pro
	cd build-linux64-qt4/ && qmake-qt4 -r ../src "DISTRIB=1" -spec linux-g++-64
gpstudio_com-linux64-qt4: build-linux64-qt4/Makefile
	cd build-linux64-qt4/ && make -j9 -f Makefile sub-gpstudio_com
gpstudio_lib-linux64-qt4: build-linux64-qt4/Makefile gpstudio_com-linux64-qt4
	cd build-linux64-qt4/ && make -j9 -f Makefile sub-gpstudio_lib
gpstudio_gui-linux64-qt4: build-linux64-qt4/Makefile gpstudio_com-linux64-qt4 gpstudio_lib-linux64-qt4
	cd build-linux64-qt4/ && make -j9 -f Makefile sub-gpstudio_gui
gpnode-linux64-qt4: build-linux64-qt4/Makefile gpstudio_com-linux64-qt4 gpstudio_lib-linux64-qt4 gpstudio_gui-linux64-qt4
	cd build-linux64-qt4/ && make -j9 -f Makefile sub-gpnode
gpviewer-linux64-qt4: build-linux64-qt4/Makefile gpstudio_com-linux64-qt4 gpstudio_lib-linux64-qt4 gpstudio_gui-linux64-qt4
	cd build-linux64-qt4/ && make -j9 -f Makefile sub-gpviewer


gui-tools-linux32-qt5: gpnode-linux32-qt5 gpviewer-linux32-qt5
build-linux32-qt5/:
	mkdir build-linux32-qt5
build-linux32-qt5/Makefile: build-linux32-qt5/ src/gpstudio.pro
	cd build-linux32-qt5/ && /opt/Qt5.2_32/bin/qmake -r ../src "DISTRIB=1" -spec linux-g++-32
gpstudio_com-linux32-qt5: build-linux32-qt5/Makefile
	cd build-linux32-qt5/ && make -j9 -f Makefile sub-gpstudio_com
gpstudio_lib-linux32-qt5: build-linux32-qt5/Makefile gpstudio_com-linux32-qt5
	cd build-linux32-qt5/ && make -j9 -f Makefile sub-gpstudio_lib
gpstudio_gui-linux32-qt5: build-linux32-qt5/Makefile gpstudio_com-linux32-qt5 gpstudio_lib-linux32-qt5
	cd build-linux32-qt5/ && make -j9 -f Makefile sub-gpstudio_gui
gpnode-linux32-qt5: build-linux32-qt5/Makefile gpstudio_com-linux32-qt5 gpstudio_lib-linux32-qt5 gpstudio_gui-linux32-qt5
	cd build-linux32-qt5/ && make -j9 -f Makefile sub-gpnode
gpviewer-linux32-qt5: build-linux32-qt5/Makefile gpstudio_com-linux32-qt5 gpstudio_lib-linux32-qt5 gpstudio_gui-linux32-qt5
	cd build-linux32-qt5/ && make -j9 -f Makefile sub-gpviewer


gui-tools-linux64-qt5: gpnode-linux64-qt5 gpviewer-linux64-qt5
build-linux64-qt5/:
	mkdir build-linux64-qt5
build-linux64-qt5/Makefile: build-linux64-qt5/ src/gpstudio.pro
	cd build-linux64-qt5/ && qmake -r ../src "DISTRIB=1" -spec linux-g++-64
gpstudio_com-linux64-qt5: build-linux64-qt5/Makefile
	cd build-linux64-qt5/ && make -j9 -f Makefile sub-gpstudio_com
gpstudio_lib-linux64-qt5: build-linux64-qt5/Makefile gpstudio_com-linux64-qt5
	cd build-linux64-qt5/ && make -j9 -f Makefile sub-gpstudio_lib
gpstudio_gui-linux64-qt5: build-linux64-qt5/Makefile gpstudio_com-linux64-qt5 gpstudio_lib-linux64-qt5
	cd build-linux64-qt5/ && make -j9 -f Makefile sub-gpstudio_gui
gpnode-linux64-qt5: build-linux64-qt5/Makefile gpstudio_com-linux64-qt5 gpstudio_lib-linux64-qt5 gpstudio_gui-linux64-qt5
	cd build-linux64-qt5/ && make -j9 -f Makefile sub-gpnode
gpviewer-linux64-qt5: build-linux64-qt5/Makefile gpstudio_com-linux64-qt5 gpstudio_lib-linux64-qt5 gpstudio_gui-linux64-qt5
	cd build-linux64-qt5/ && make -j9 -f Makefile sub-gpviewer


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
	rm -f ../bin/*.so* ../bin/*.dll

FORCE:

