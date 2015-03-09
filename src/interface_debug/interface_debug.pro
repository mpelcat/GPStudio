QT       += core gui xml script

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = interface_debug
TEMPLATE = app

OUT_PWD = ../interface_debug/
DESTDIR = ../interface_debug/

QMAKE_CFLAGS_RELEASE = -O2

SOURCES += main.cpp \
    mainwindow.cpp \
    connectnodedialog.cpp

HEADERS  += \
    mainwindow.h \
    connectnodedialog.h

FORMS    += \
    mainwindow.ui \
    connectnodedialog.ui

RESOURCES += icons.qrc

# gpstudio_lib lib
INCLUDEPATH += $$PWD/../gpstudio_lib
DEPENDPATH += $$PWD/../gpstudio_lib
win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../gpstudio_lib/release/ -lgpstudio_lib
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../gpstudio_lib/debug/ -lgpstudio_lib
else:unix: LIBS += -L$$OUT_PWD/../gpstudio_lib/ -lgpstudio_lib

# gpstudio_com lib
INCLUDEPATH += $$PWD/../gpstudio_com
DEPENDPATH += $$PWD/../gpstudio_com
win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../gpstudio_com/release/ -lgpstudio_com
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../gpstudio_com/debug/ -lgpstudio_com
else:unix: LIBS += -L$$OUT_PWD/../gpstudio_com/ -lgpstudio_com

# gpstudio_gui lib
INCLUDEPATH += $$PWD/../gpstudio_gui
DEPENDPATH += $$PWD/../gpstudio_gui
win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../gpstudio_gui/release/ -lgpstudio_gui
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../gpstudio_gui/debug/ -lgpstudio_gui
else:unix: LIBS += -L$$OUT_PWD/../gpstudio_gui/ -lgpstudio_gui

use_open_cv {
    win32 {
        INCLUDEPATH += "E:\opencv\include"
        LIBS += -L"E:\opencv\x86\mingw\bin" -lopencv_core249 -lopencv_highgui249 -lopencv_imgproc249
    }
    unix {
        LIBS += -lopencv_core -lopencv_highgui -lopencv_imgproc
    }
}

win32: LIBS += -L$$PWD/../../thirdparts/libusb-1.0/
LIBS += -lusb-1.0
