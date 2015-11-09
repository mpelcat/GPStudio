
all: gui-tools

gui-tools: gpnode gpviewer

install: gui-tools
	cp -r bin-linux/libgpstudio_com.so ../bin
	cp -r bin-linux/libgpstudio_com.so.1 ../bin
	cp -r bin-linux/libgpstudio_com.so.1.0 ../bin
	cp -r bin-linux/libgpstudio_com.so.1.0.0 ../bin
	cp -r bin-linux/libgpstudio_gui.so ../bin
	cp -r bin-linux/libgpstudio_gui.so.1 ../bin
	cp -r bin-linux/libgpstudio_gui.so.1.0 ../bin
	cp -r bin-linux/libgpstudio_gui.so.1.0.0 ../bin
	cp -r bin-linux/libgpstudio_lib.so ../bin
	cp -r bin-linux/libgpstudio_lib.so.1 ../bin
	cp -r bin-linux/libgpstudio_lib.so.1.0 ../bin
	cp -r bin-linux/libgpstudio_lib.so.1.0.0 ../bin
	cp -r bin-linux/gpviewer ../bin
	cp -r bin-linux/gpnode_gui ../bin

build-linux/:
	mkdir build-linux

build-linux/Makefile: build-linux/ src/gpstudio.pro
	cd build-linux/ && qmake ../src

gpstudio_com: build-linux/Makefile
	cd build-linux/ && make -j9 -f Makefile sub-gpstudio_com

gpstudio_lib: build-linux/Makefile gpstudio_com
	cd build-linux/ && make -j9 -f Makefile sub-gpstudio_lib

gpstudio_gui: build-linux/Makefile gpstudio_com gpstudio_lib
	cd build-linux/ && make -j9 -f Makefile sub-gpstudio_gui

gpnode: build-linux/Makefile gpstudio_com gpstudio_lib gpstudio_gui
	cd build-linux/ && make -j9 -f Makefile sub-gpnode

gpviewer: build-linux/Makefile gpstudio_com gpstudio_lib gpstudio_gui
	cd build-linux/ && make -j9 -f Makefile sub-gpviewer

FORCE:

