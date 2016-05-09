QT       += core gui xml script svg

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets printsupport

TARGET = gpstudio_gui
TEMPLATE = lib

OUT_PWD = ../gpstudio_gui/
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

DEFINES += GPSTUDIO_GUI_EXPORT_LIB

QMAKE_CFLAGS_RELEASE = -O2

SOURCES += \
    propertywidgets/propertywidget.cpp \
    propertywidgets/propertygroupwidget.cpp \
    propertywidgets/propertyintwidget.cpp \
    propertywidgets/propertysintwidget.cpp \
    propertywidgets/propertyboolwidget.cpp \
    propertywidgets/propertyenumwidget.cpp \
    scriptwidget.cpp \
    scriptlineedit.cpp \
    viewmodelwidget/camtreeview.cpp \
    viewmodelwidget/caminfoitemmodel.cpp \
    viewmodelwidget/libitemmodel.cpp \
    viewmodelwidget/libtreeview.cpp \
    viewmodelwidget/cameraitemmodel.cpp \
    viewmodelwidget/cameraitem.cpp \
    viewmodelwidget/propertyitemmodel.cpp \
    propertywidgets/propertymatrixwidget.cpp \
    flowviewerwidget/flowviewerwidget.cpp \
    flowviewerwidget/abstractviewer.cpp \
    viewer/layerwidget.cpp \
    camexplorerwidget.cpp \
    flowviewerwidget/layerviewer.cpp \
    flowviewerwidget/hexviewer.cpp \
    flowviewerwidget/plotviewer.cpp \
    itemsview/blockitem.cpp \
    itemsview/blockscene.cpp \
    itemsview/blockconnectoritem.cpp \
    itemsview/blockportitem.cpp \
    itemsview/blockview.cpp \
    blockeditor/blockeditorwindow.cpp \
    blockeditor/codeeditor.cpp \
    blockeditor/syntaxhighlight/abstractsyntax.cpp \
    blockeditor/syntaxhighlight/vhdlsyntax.cpp \
    blockeditor/syntaxhighlight/xmlsyntax.cpp \
    blockeditor/syntaxhighlight/verilogsyntax.cpp \
    blockeditor/syntaxhighlight/tclsyntax.cpp \
    viewer/docviewer.cpp \
    viewer/pdfviewer.cpp

HEADERS  += \
    gpstudio_gui_common.h \
    propertywidgets/propertywidgets.h \
    propertywidgets/propertywidget.h \
    propertywidgets/propertygroupwidget.h \
    propertywidgets/propertyintwidget.h \
    propertywidgets/propertysintwidget.h \
    propertywidgets/propertyboolwidget.h \
    propertywidgets/propertyenumwidget.h \
    scriptwidget.h \
    scriptlineedit.h \
    viewmodelwidget/camtreeview.h \
    viewmodelwidget/caminfoitemmodel.h \
    viewmodelwidget/libitemmodel.h \
    viewmodelwidget/libtreeview.h \
    viewmodelwidget/cameraitemmodel.h \
    viewmodelwidget/cameraitem.h \
    viewmodelwidget/propertyitemmodel.h \
    propertywidgets/propertymatrixwidget.h \
    flowviewerwidget/flowviewerwidget.h \
    flowviewerwidget/abstractviewer.h \
    viewer/layerwidget.h \
    camexplorerwidget.h \
    flowviewerwidget/layerviewer.h \
    flowviewerwidget/hexviewer.h \
    flowviewerwidget/plotviewer.h \
    itemsview/blockitem.h \
    itemsview/blockscene.h \
    itemsview/blockconnectoritem.h \
    itemsview/blockportitem.h \
    itemsview/blockview.h \
    blockeditor/blockeditorwindow.h \
    blockeditor/codeeditor.h \
    blockeditor/syntaxhighlight/abstractsyntax.h \
    blockeditor/syntaxhighlight/vhdlsyntax.h \
    blockeditor/syntaxhighlight/xmlsyntax.h \
    blockeditor/syntaxhighlight/verilogsyntax.h \
    blockeditor/syntaxhighlight/tclsyntax.h \
    viewer/docviewer.h \
    viewer/pdfviewer.h

RESOURCES += \
    icons.qrc \
    flowvieweractions.qrc \
    flowviewertypes.qrc

include(../../thirdparts/hexedit/hexedit.pri)
include(../../thirdparts/qcustomplot/qcustomplot.pri)

# gpstudio_lib lib
INCLUDEPATH += $$PWD/../gpstudio_lib
DEPENDPATH += $$PWD/../gpstudio_lib
LIBS += -lgpstudio_lib

# gpstudio_com lib
INCLUDEPATH += $$PWD/../gpstudio_com
DEPENDPATH += $$PWD/../gpstudio_com
LIBS += -lgpstudio_com

use_open_cv {
    DEFINES += __USE_OPEN_CV__
    win32 {
        INCLUDEPATH += "E:\opencv\include"
        LIBS += -L"E:\opencv\x86\mingw\bin" -lopencv_core249 -lopencv_highgui249 -lopencv_imgproc249
    }
}
