#include "mainwindow.h"
#include "ui_mainwindow.h"

#include "lib_parser/lib.h"
#include "model/node.h"

#include <QDebug>

#include <QScriptEngine>

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

    foreach (Block *block, node->blocks())
    {
        qDebug()<<block->name();
        foreach (Param *param, block->params())
        {
            if(param->isDynamicParam()) qDebug()<<'\t'<<param->name()<<param->absoluteAddr();
        }
    }

    delete node;
}

void MainWindow::on_pushButton_2_clicked()
{
    QScriptEngine e;
    QScriptValue a(ui->lineEdit->text().toInt());

    QObject *someObject = this;
    QScriptValue objectValue = e.newQObject(someObject);
    e.globalObject().setProperty("myObject", objectValue);
    e.globalObject().setProperty("a", a);
    qDebug()<<e.evaluate(ui->lineEdit_2->text()).toString();
}
