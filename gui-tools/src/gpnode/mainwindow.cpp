/****************************************************************************
** Copyright (C) 2016 Dream IP
** 
** This file is part of GPStudio.
**
** GPStudio is a free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program.  If not, see <http://www.gnu.org/licenses/>.
**
****************************************************************************/

#include "mainwindow.h"
#include "ui_mainwindow.h"

#include "model/model_node.h"
#include "model/model_parambitfield.h"

#include <QDebug>
#include <QRegExp>
#include <QAction>

#include "propertywidgets/propertywidgets.h"

#include "confignodedialog.h"

#include "itemsview/blockitem.h"
#include "itemsview/blockportitem.h"
#include "itemsview/blockconnectoritem.h"

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

    // tests
    BlockItem *hog1 = new BlockItem(_project->lib()->process("HOG"));
    BlockPortItem *portItem = new BlockPortItem();
    portItem->setPos(5,30);
    hog1->addPort(portItem);
    BlockPortItem *portItem2 = new BlockPortItem();
    portItem2->setPos(5,70);
    hog1->addPort(portItem2);
    BlockPortItem *portItem3 = new BlockPortItem();
    portItem3->setPos(155,50);
    hog1->addPort(portItem3);
    ui->processView->blockScene()->addItem(hog1);

    BlockItem *hog2 = new BlockItem(_project->lib()->process("conv"));
    BlockPortItem *portItem4 = new BlockPortItem();
    portItem4->setPos(5,50);
    hog2->addPort(portItem4);
    hog2->setPos(300, 0);
    ui->processView->blockScene()->addItem(hog2);

    BlockConnectorItem *connector = new BlockConnectorItem(portItem3 ,portItem4);
    ui->processView->blockScene()->addItem(connector);
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

    /*QMenu *viewMenu = */ui->menuBar->addMenu("&View");
    /*QMenu *helpMenu = */ui->menuBar->addMenu("&Help");
}

void MainWindow::configNode()
{
    ConfigNodeDialog configNodeDialog(this);
    configNodeDialog.setProject(_project);
    configNodeDialog.exec();
}
