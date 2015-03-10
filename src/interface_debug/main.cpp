#include "mainwindow.h"
#include <QApplication>

#include <QDebug>
#include <QDir>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    MainWindow w(a.arguments());
    w.show();

    return a.exec();
}
