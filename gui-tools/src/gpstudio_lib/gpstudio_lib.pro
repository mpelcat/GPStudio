QT       += core xml script svg

TARGET = gpstudio_lib
TEMPLATE = lib

OUT_PWD = ../gpstudio_lib/
equals(DISTRIB, 1) {
    win32 {
        DESTDIR = ../../bin-win64-qt5/
        LIBS += -L../../bin-win64-qt5/
    }
    linux-g++-32 {
		greaterThan(QT_MAJOR_VERSION, 4) {
			DESTDIR = ../../bin-linux32-qt5/
			LIBS += -L../../bin-linux32-qt5/
		} else {
			DESTDIR = ../../bin-linux32-qt4/
			LIBS += -L../../bin-linux32-qt4/
        }
    }
    linux-g++-64 {
		greaterThan(QT_MAJOR_VERSION, 4) {
			DESTDIR = ../../bin-linux64-qt5/
			LIBS += -L../../bin-linux64-qt5/
		} else {
			DESTDIR = ../../bin-linux64-qt4/
			LIBS += -L../../bin-linux64-qt4/
        }
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
    lib_parser/lib.h \
    lib_parser/boardlib.h \
    lib_parser/iolib.h \
    lib_parser/ioboardlib.h \
    lib_parser/iolibgroup.h \
    camera/camera.h \
    camera/property.h \
    propertyclass.h \
    scriptengine.h \
    camera/propertyenum.h \
    datawrapper/datawrapper.h \
    datawrapper/gradiantwrapper.h \
    datawrapper/harriswrapper.h \
    gpnodeproject.h \
    camera/flowmanager.h \
    camera/flowconnection.h \
    flowviewerinterface.h \
    model/model_attribute.h \
    model/model_block.h \
    model/model_ciblock.h \
    model/model_clock.h \
    model/model_comconnect.h \
    model/model_fiblock.h \
    model/model_file.h \
    model/model_flow.h \
    model/model_flowconnect.h \
    model/model_io.h \
    model/model_iocom.h \
    model/model_node.h \
    model/model_param.h \
    model/model_parambitfield.h \
    model/model_piblock.h \
    model/model_pin.h \
    model/model_port.h \
    model/model_process.h \
    model/model_reset.h \
    model/model_treeconnect.h \
    model/model_treeitem.h \
    model/model_property.h \
    model/model_propertyenum.h \
    camera/registermanager.h \
    camera/registerbitfield.h \
    camera/register.h \
    camera/flow.h \
    camera/block.h

SOURCES += \
    lib_parser/processlib.cpp \
    lib_parser/lib.cpp \
    lib_parser/boardlib.cpp \
    lib_parser/iolib.cpp \
    lib_parser/ioboardlib.cpp \
    lib_parser/iolibgroup.cpp \
    camera/camera.cpp \
    camera/property.cpp \
    propertyclass.cpp \
    scriptengine.cpp \
    camera/propertyenum.cpp \
    datawrapper/datawrapper.cpp \
    datawrapper/gradiantwrapper.cpp \
    datawrapper/harriswrapper.cpp \
    gpnodeproject.cpp \
    camera/flowmanager.cpp \
    camera/flowconnection.cpp \
    flowviewerinterface.cpp \
    model/model_attribute.cpp \
    model/model_block.cpp \
    model/model_ciblock.cpp \
    model/model_clock.cpp \
    model/model_comconnect.cpp \
    model/model_fiblock.cpp \
    model/model_file.cpp \
    model/model_flow.cpp \
    model/model_flowconnect.cpp \
    model/model_io.cpp \
    model/model_iocom.cpp \
    model/model_node.cpp \
    model/model_param.cpp \
    model/model_parambitfield.cpp \
    model/model_piblock.cpp \
    model/model_pin.cpp \
    model/model_port.cpp \
    model/model_process.cpp \
    model/model_reset.cpp \
    model/model_treeconnect.cpp \
    model/model_treeitem.cpp \
    model/model_property.cpp \
    model/model_propertyenum.cpp \
    camera/registermanager.cpp \
    camera/registerbitfield.cpp \
    camera/register.cpp \
    camera/flow.cpp \
    camera/block.cpp

# gpstudio_com lib
INCLUDEPATH += $$PWD/../gpstudio_com
DEPENDPATH += $$PWD/../gpstudio_com
LIBS += -lgpstudio_com

DISTFILES += \
    flowviewermodel.qmodel

RESOURCES += \
    connecttypes.qrc
