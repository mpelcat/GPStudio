#include "mainwindow.h"
#include "ui_mainwindow.h"

#include "lib_parser/lib.h"
#include "model/node.h"

#include <QDebug>

#include <QScriptEngine>

#include "propertywidgets/propertywidgets.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    _cam = NULL;
}

MainWindow::~MainWindow()
{
    delete ui;
    delete _cam;
}

void MainWindow::on_pushButton_clicked()
{
    //Lib lib("../../../GPStudio_lib_std/");

    QString fileNameCam = "../../../std_project/node_generated.xml";
#ifdef Q_WS_WIN
    fileNameCam.prepend("../");
#endif
    _cam = new Camera(fileNameCam);

    if(_cam)
    {
        foreach (Property *property, _cam->paramsBlocks()->subProperties().properties())
        {
            PropertyWidget *propertyWidget = PropertyWidget::getWidgetFromProperty(property);
            ui->blocksParamsLayout->addWidget(propertyWidget);
        }
    }
}

void MainWindow::on_pushButton_2_clicked()
{
    QScriptEngine e;
    QScriptValue a(ui->lineEdit->text().toInt());

    QObject *someObject = this;
    QScriptValue objectValue = e.newQObject(someObject);
    e.globalObject().setProperty("myObject", objectValue);
    e.globalObject().setProperty("a", a);
    const QScriptValue &result = e.evaluate(ui->lineEdit_2->text());
    qDebug()<<result.toString()<<e.uncaughtExceptionBacktrace();
}
