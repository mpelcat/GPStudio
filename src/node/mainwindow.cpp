#include "mainwindow.h"
#include "ui_mainwindow.h"

#include "lib_parser/lib.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_pushButton_clicked()
{
    Lib lib("../../GPStudio_lib_std/");
}
