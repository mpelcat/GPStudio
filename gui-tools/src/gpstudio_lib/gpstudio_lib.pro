QT       += core xml script svg

TARGET = gpstudio_lib
TEMPLATE = lib

OUT_PWD = ../gpstudio_lib/
equals(DISTRIB, 1) {
    win32 {
        DESTDIR = ../../bin-win/
        LIBS += -L../../bin-win/
    }
    unix {
        DESTDIR = ../../bin-linux/
        LIBS += -L../../bin-linux/
    }
} else {
    DESTDIR = ../../../bin/
    LIBS += -L../../../bin/
}

DEFINES += GPSTUDIO_LIB_EXPORT_LIB

QMAKE_CFLAGS_RELEASE = -O2

INCLUDEPATH += $$PWD

HEADERS += gpstudio_lib_common.h \
    lib_parser/processlib.h \
    lib_parser/processlibreader.h \
    lib_parser/lib.h \
    lib_parser/boardlib.h \
    model/node.h \
    model/block.h \
    model/io.h \
    model/process.h \
    model/file.h \
    model/param.h \
    model/flow.h \
    model/clock.h \
    model/reset.h \
    model/port.h \
    model/pin.h \
    model/parambitfield.h \
    model/attribute.h \
    camera.h \
    property.h \
    cameraregister.h \
    propertiesmap.h \
    model/blockpropertyenum.h \
    model/blockproperty.h \
    propertyclass.h \
    cameraregistersmap.h \
    cameraregisterbitfield.h \
    lib_parser/iolib.h \
    scriptengine.h \
    propertyenum.h \
    datawrapper/datawrapper.h \
    datawrapper/gradiantwrapper.h \
    datawrapper/harriswrapper.h \
    gpnodeproject.h \
    lib_parser/iolibgroup.h

SOURCES += \
    lib_parser/processlib.cpp \
    lib_parser/processlibreader.cpp \
    lib_parser/lib.cpp \
    lib_parser/boardlib.cpp \
    model/node.cpp \
    model/block.cpp \
    model/io.cpp \
    model/process.cpp \
    model/file.cpp \
    model/param.cpp \
    model/flow.cpp \
    model/clock.cpp \
    model/reset.cpp \
    model/port.cpp \
    model/pin.cpp \
    model/parambitfield.cpp \
    model/attribute.cpp \
    camera.cpp \
    property.cpp \
    cameraregister.cpp \
    propertiesmap.cpp \
    model/blockpropertyenum.cpp \
    model/blockproperty.cpp \
    propertyclass.cpp \
    cameraregistersmap.cpp \
    cameraregisterbitfield.cpp \
    lib_parser/iolib.cpp \
    scriptengine.cpp \
    propertyenum.cpp \
    datawrapper/datawrapper.cpp \
    datawrapper/gradiantwrapper.cpp \
    datawrapper/harriswrapper.cpp \
    gpnodeproject.cpp \
    lib_parser/iolibgroup.cpp

# gpstudio_com lib
INCLUDEPATH += $$PWD/../gpstudio_com
DEPENDPATH += $$PWD/../gpstudio_com
LIBS += -lgpstudio_com
