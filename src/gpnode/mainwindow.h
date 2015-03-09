#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

#include "lib_parser/lib.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

    void createToolBarAndMenu();

private slots:
    void configNode();

private:
    Ui::MainWindow *ui;

    Lib *_lib;
};

#endif // MAINWINDOW_H
