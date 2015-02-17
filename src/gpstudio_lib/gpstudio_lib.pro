QT       += core xml

TARGET = gpstudio_lib
TEMPLATE = lib

DEFINES += GPSTUDIO_LIB_EXPORT_LIB

QMAKE_CFLAGS_RELEASE = -O2

INCLUDEPATH += $$PWD

HEADERS += gpstudio_lib_common.h \
    lib_parser/processlib.h \
    lib_parser/processlibreader.h \
    lib_parser/lib.h

SOURCES += \
    lib_parser/processlib.cpp \
    lib_parser/processlibreader.cpp \
    lib_parser/lib.cpp
