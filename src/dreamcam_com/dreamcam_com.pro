#-------------------------------------------------
#
# Project created by QtCreator 2014-10-14T11:27:37
#
#-------------------------------------------------

QT       += core gui

TARGET = dreamcam_com
TEMPLATE = lib

DEFINES += DREAMCAMCOM_EXPORT_LIB

SOURCES += cameraio.cpp \
    camerausb.cpp \
    camera.cpp \
    camerainfo.cpp \
    cameraudp.cpp \
    flow.cpp \
    flowdata.cpp

HEADERS  += cameraio.h \
    camerausb.h \
    camera.h \
    camerainfo.h \
    cameraudp.h \
    flow.h \
    flowdata.h \
    dreamcam_com.h

LIBS += -L$$PWD/../dreamcam_com -lusb-1.0




