#include "mainwindow.h"
#include "ui_mainwindow.h"

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

    _project = new GPNodeProject();

    ui->libTreeView->setLib(_project->lib());
    ui->processView->setLib(_project->lib());
}

MainWindow::~MainWindow()
{
    delete ui;
    delete _project;
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
    ui->mainToolBar->addSeparator();

    QAction *configNode = new QAction("&Configure node",this);
    configNode->setIcon(QIcon(":/icons/img/settings.png"));
    saveDocAction->setShortcut(QKeySequence::Preferences);
    fileMenu->addAction(configNode);
    ui->mainToolBar->addAction(configNode);
    connect(configNode, SIGNAL(triggered()), this, SLOT(configNode()));

    QMenu *viewMenu = ui->menuBar->addMenu("&View");
    QMenu *helpMenu = ui->menuBar->addMenu("&Help");
}

void MainWindow::configNode()
{
    ConfigNodeDialog configNodeDialog(this);
    configNodeDialog.setProject(_project);
    configNodeDialog.exec();
}
