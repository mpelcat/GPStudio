#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

#include "gpnodeproject.h"

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

    GPNodeProject *_project;
};

#endif // MAINWINDOW_H
