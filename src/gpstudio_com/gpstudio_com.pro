QT       += core

TARGET = gpstudio_com
TEMPLATE = lib

DEFINES += GPSTUDIO_COM_EXPORT_LIB

QMAKE_CFLAGS_RELEASE = -O2

SOURCES += cameraio.cpp \
    camerausb.cpp \
    camera.cpp \
    camerainfo.cpp \
    cameraudp.cpp \
    flow.cpp \
    flowdata.cpp

HEADERS  += \
    cameraio.h \
    camerausb.h \
    camera.h \
    camerainfo.h \
    cameraudp.h \
    flow.h \
    flowdata.h \
    gpstudio_com_common.h

LIBS += -L$$PWD/../gpstudio_com -lusb-1.0
