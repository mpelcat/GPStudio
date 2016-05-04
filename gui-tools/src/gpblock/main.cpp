#include <QApplication>

#include "blockeditor/blockeditorwindow.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    BlockEditorWindow w;
    w.show();

    return a.exec();
}
