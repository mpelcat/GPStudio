QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets printsupport

TARGET = gpstudio_gui
TEMPLATE = lib

DEFINES += GPSTUDIO_GUI_EXPORT_LIB

QMAKE_CFLAGS_RELEASE = -O2

SOURCES += camtreeview.cpp \
    caminfoitemmodel.cpp \
    imageview.cpp

HEADERS  += \
    camtreeview.h \
    caminfoitemmodel.h \
    imageview.h \
    gpstudio_gui_common.h

include(../../thirdparts/hexedit/hexedit.pri)
include(../../thirdparts/qcustomplot/qcustomplot.pri)

# dream_cam_com lib
INCLUDEPATH += $$PWD/../gpstudio_com
DEPENDPATH += $$PWD/../gpstudio_com
win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../gpstudio_com/release -ldreamcam_com
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../gpstudio_com/debug -ldreamcam_com
else:unix: LIBS += -L$$OUT_PWD/../gpstudio_com -lgpstudio_com

win32 {
    INCLUDEPATH += "E:\opencv\include"
    LIBS += -L"E:\opencv\x86\mingw\bin" -lopencv_core249 -lopencv_highgui249 -lopencv_imgproc249
}
