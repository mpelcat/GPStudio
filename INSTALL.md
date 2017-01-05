# GPStudio installation

Important, if you are using a zip or tar package, you need to add the
bin directory to your PATH. Under Windows, add also thirdparts/ and 
thirdparts/php.

You may need a distribution of quartus 13.1 for the dreamcam.

## Dependencies

* make (with bin in your path) to generate your projects
* php5-cli (with php bin in your path) to execute command lines tools and 
back-end generation
* Qt (with qmake bin in your path) Qt 4.7 or more recent version (Qt5 
supported) for GUI tools
* quartus (with bin in your path) if you want to use atlera branded FPGA
* libusb for USB camera comunication

For PHP7, you need to install : php7.0-mbstring php7.0-zip php7.0-xml

    sudo apt-get install php7.0-mbstring php7.0-zip php7.0-xml

Optionnal :

* graphviz (optional) to draw process connection in command line mode with dot

> sudo apt-get install make php5-cli 

## GUI tools compilation

### Command line mode

To compile gpviewer and gpnode_gui, open a terminal in GPStudio root 
directory and just type:

> make gui-tools

In case it does not work, check if you have a distribution of Qt:

> qmake -v

To install Qt5 with apt (linux Debian/Ubuntu):

> sudo apt-get install g++ libusb-1.0-0-dev qtbase5-dev qtbase5-dev-tools qt5-default 

You may also need:

> sudo apt-get install qtscript5-dev libqt5svg5-dev qttools5-dev libpoppler-qt5-dev

To install Qt4 with apt (old Debian/Ubuntu versions):

> sudo apt-get install g++ libusb-1.0-0-dev libqt4-dev

You may also need:

> sudo apt-get install qt4-dev-tools libqtscript4-core libpoppler-qt4-dev

You also can download it from <https://www.qt.io/download-open-source/>

### Graphical mode

Download a Qt package with Qt Creator at <https://www.qt.io/download-open-source/>
and install it.

Open Qt Creator and open the project gui-tools/src/gpstudio.pro.

Configure the project to be compiled in gui-tools/build. (important)

Click on compile and run or Ctrl + R. Enjoy.
