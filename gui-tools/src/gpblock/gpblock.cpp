#include <QApplication>

#include "blockeditor/blockeditorwindow.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    ModelBlock *modelBlock = NULL;

    if(a.arguments().size()>1)
    {
        QString blockFileName = a.arguments()[1];
        modelBlock = ModelBlock::readFromFile(blockFileName);
    }

    BlockEditorWindow w(NULL, modelBlock);
    w.show();

    return a.exec();
}
