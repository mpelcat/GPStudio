#include "mainwindow.h"
#include <QApplication>

#include <QDebug>
#include <QDir>
#include <QSplashScreen>
#include <QTimer>
#include <QLabel>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w(a.arguments());

    /*QSplashScreen splashScreen(QPixmap("../../src/img/GPS_SS.png"));
    QLabel *label = new QLabel("loading...loading...loading...loading...",&splashScreen);
    label->move(200,360);
    splashScreen.show();
    splashScreen.showMessage("Loaded modules");
    a.processEvents();

    QTimer::singleShot(5000, &splashScreen, SLOT(close()));
    QTimer::singleShot(5000, &w, SLOT(show()));*/

    //splashScreen.finish(&w);

    w.show();

    return a.exec();
}
