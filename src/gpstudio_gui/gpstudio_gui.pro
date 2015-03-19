QT       += core gui xml script svg

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets printsupport

TARGET = gpstudio_gui
TEMPLATE = lib

DEFINES += GPSTUDIO_GUI_EXPORT_LIB

QMAKE_CFLAGS_RELEASE = -O2

SOURCES += viewmodelwidget/camtreeview.cpp \
    viewmodelwidget/caminfoitemmodel.cpp \
    imageview.cpp \
    propertywidgets/propertywidget.cpp \
    propertywidgets/propertygroupwidget.cpp \
    propertywidgets/propertyintwidget.cpp \
    propertywidgets/propertysintwidget.cpp \
    propertywidgets/propertyboolwidget.cpp \
    propertywidgets/propertyenumwidget.cpp \
    scriptwidget.cpp \
    scriptlineedit.cpp \
    viewmodelwidget/libitemmodel.cpp \
    viewmodelwidget/libtreeview.cpp \
    itemsview/processesview.cpp \
    itemsview/processesscene.cpp \
    itemsview/processitem.cpp

HEADERS  += \
    viewmodelwidget/camtreeview.h \
    viewmodelwidget/caminfoitemmodel.h \
    imageview.h \
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
    viewmodelwidget/libitemmodel.h \
    viewmodelwidget/libtreeview.h \
    itemsview/processesview.h \
    itemsview/processesscene.h \
    itemsview/processitem.h

include(../../thirdparts/hexedit/hexedit.pri)
include(../../thirdparts/qcustomplot/qcustomplot.pri)

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

use_open_cv {
    DEFINES += __USE_OPEN_CV__
    win32 {
        INCLUDEPATH += "E:\opencv\include"
        LIBS += -L"E:\opencv\x86\mingw\bin" -lopencv_core249 -lopencv_highgui249 -lopencv_imgproc249
    }
}
