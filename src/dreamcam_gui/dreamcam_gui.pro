#-------------------------------------------------
#
# Project created by QtCreator 2014-10-14T11:27:37
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = dreamcam_gui
TEMPLATE = lib

DEFINES += DREAMCAMGUI_EXPORT_LIB

SOURCES += hexedit/commands.cpp \
    hexedit/qhexedit.cpp \
    hexedit/qhexedit_p.cpp \
    hexedit/xbytearray.cpp \
    camtreeview.cpp \
    caminfoitemmodel.cpp \
    imageview.cpp

HEADERS  += hexedit/commands.h \
    hexedit/qhexedit.h \
    hexedit/qhexedit_p.h \
    hexedit/xbytearray.h \
    camtreeview.h \
    caminfoitemmodel.h \
    imageview.h \
    dreamcam_gui.h

# dream_cam_com lib
INCLUDEPATH += $$PWD/../dreamcam_com
DEPENDPATH += $$PWD/../dreamcam_com
win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../dreamcam_com/release -ldreamcam_com
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../dreamcam_com/debug -ldreamcam_com
else:unix: LIBS += -L$$OUT_PWD/../dreamcam_com -ldreamcam_com

win32 {
    INCLUDEPATH += "E:\opencv\include"
    LIBS += -L"E:\opencv\x86\mingw\bin" -lopencv_core249 -lopencv_highgui249 -lopencv_imgproc249
}
