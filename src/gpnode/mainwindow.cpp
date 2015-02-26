#include "mainwindow.h"
#include "ui_mainwindow.h"

#include "lib_parser/lib.h"
#include "model/node.h"

#include <QDebug>

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
    //Lib lib("../../../GPStudio_lib_std/");

    const Node *node = Node::readFromFile("../../../std_project/node_generated.xml");
    qDebug()<<node->name();
    delete node;
}
