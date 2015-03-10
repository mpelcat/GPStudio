#include "mainwindow.h"
#include "ui_mainwindow.h"

#include "lib_parser/lib.h"
#include "model/node.h"
#include "model/parambitfield.h"

#include <QDebug>
#include <QRegExp>
#include <QAction>

#include "propertywidgets/propertywidgets.h"

#include "confignodedialog.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    createToolBarAndMenu();

    //if(QFile::exists("../../../std_project/node_generated.xml")) openNodeGeneratedFile("../../../std_project/node_generated.xml");
    _lib = new Lib("../../../GPStudio_lib_std");

    qDebug()<<ParamBitField::listBitFromBitField("5-0");
    qDebug()<<ParamBitField::listBitFromBitField("5,0");
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::createToolBarAndMenu()
{
    // ============= File =============
    QMenu *fileMenu = ui->menuBar->addMenu("&File");

    QAction *newDocAction = new QAction("&New",this);
    newDocAction->setIcon(QIcon(":/icons/img/new.png"));
    newDocAction->setShortcut(QKeySequence::New);
    ui->mainToolBar->addAction(newDocAction);
    fileMenu->addAction(newDocAction);

    QAction *openDocAction = new QAction("&Open",this);
    openDocAction->setIcon(QIcon(":/icons/img/open.png"));
    openDocAction->setShortcut(QKeySequence::Open);
    ui->mainToolBar->addAction(openDocAction);
    fileMenu->addAction(openDocAction);

    QAction *saveDocAction = new QAction("&Save",this);
    saveDocAction->setIcon(QIcon(":/icons/img/save.png"));
    saveDocAction->setShortcut(QKeySequence::Save);
    ui->mainToolBar->addAction(saveDocAction);
    fileMenu->addAction(saveDocAction);

    fileMenu->addSeparator();

    QAction *configNode = new QAction("&Configure node",this);
    fileMenu->addAction(configNode);
    connect(configNode, SIGNAL(triggered()), this, SLOT(configNode()));
}

void MainWindow::configNode()
{
    ConfigNodeDialog configNodeDialog(this);
    configNodeDialog.setLib(_lib);
    configNodeDialog.exec();
}
