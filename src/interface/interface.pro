#-------------------------------------------------
#
# Project created by QtCreator 2014-10-14T11:27:37
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = interface_dream_cam
TEMPLATE = app

OUT_PWD = ../interface/
DESTDIR = ../interface/

SOURCES += main.cpp\
        mainwindow.cpp

HEADERS  += mainwindow.h

FORMS    += mainwindow.ui

# dream_cam_com lib
INCLUDEPATH += $$PWD/../dreamcam_com
DEPENDPATH += $$PWD/../dreamcam_com
win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../dreamcam_com/release -ldreamcam_com
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../dreamcam_com/debug -ldreamcam_com
else:unix: LIBS += -L$$OUT_PWD/../dreamcam_com -ldreamcam_com

# dream_cam_gui lib
INCLUDEPATH += $$PWD/../dreamcam_gui
DEPENDPATH += $$PWD/../dreamcam_gui
win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../dreamcam_gui/release -ldreamcam_gui
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../dreamcam_gui/debug -ldreamcam_gui
else:unix: LIBS += -L$$OUT_PWD/../dreamcam_gui -ldreamcam_gui

win32 {
    INCLUDEPATH += "E:\opencv\include"
    LIBS += -L"E:\opencv\x86\mingw\bin" -lopencv_core249 -lopencv_highgui249 -lopencv_imgproc249
}
unix {
    LIBS += -lopencv_core -lopencv_highgui -lopencv_imgproc
}
