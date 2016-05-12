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

#include "undostack/blockcommands.h"

MainWindow::MainWindow(QStringList args) :
    QMainWindow(0),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    createToolBarAndMenu();

    _project = new GPNodeProject(this);

    ui->processView->setEditMode(true);
    ui->libTreeView->setLib(&Lib::getLib());

    if(args.size()>1)
    {
        if(QFile::exists(args[1]))
        {
            _node = ModelNode::readFromFile(args[1]);
             ui->processView->loadFromNode(_node);
        }
    }

    connect(ui->processView, SIGNAL(blockMoved(ModelBlock*,QPoint,QPoint)),
            this, SLOT(moveBlock(ModelBlock*,QPoint,QPoint)));
}

MainWindow::~MainWindow()
{
    delete _project;
    delete ui;
}

void MainWindow::createToolBarAndMenu()
{
    // ============= Edit =============
    QMenu *nodeMenu = ui->menuBar->addMenu("&Node");

    QAction *newDocAction = new QAction("&New",this);
    newDocAction->setIcon(QIcon(":/icons/img/new.png"));
    newDocAction->setShortcut(QKeySequence::New);
    ui->mainToolBar->addAction(newDocAction);
    nodeMenu->addAction(newDocAction);

    QAction *openDocAction = new QAction("&Open",this);
    openDocAction->setIcon(QIcon(":/icons/img/open.png"));
    openDocAction->setShortcut(QKeySequence::Open);
    ui->mainToolBar->addAction(openDocAction);
    nodeMenu->addAction(openDocAction);

    QAction *saveDocAction = new QAction("&Save",this);
    saveDocAction->setIcon(QIcon(":/icons/img/save.png"));
    saveDocAction->setShortcut(QKeySequence::Save);
    ui->mainToolBar->addAction(saveDocAction);
    nodeMenu->addAction(saveDocAction);

    nodeMenu->addSeparator();
    ui->mainToolBar->addSeparator();

    QAction *configNode = new QAction("&Configure node",this);
    configNode->setIcon(QIcon(":/icons/img/settings.png"));
    saveDocAction->setShortcut(QKeySequence::Preferences);
    nodeMenu->addAction(configNode);
    ui->mainToolBar->addAction(configNode);
    connect(configNode, SIGNAL(triggered()), this, SLOT(configNode()));

    // ============= Edit =============
    QMenu *editMenu = ui->menuBar->addMenu("&Edit");
    ui->mainToolBar->addSeparator();

    QAction *undoAction = _undoStack.createUndoAction(this, "&Undo");
    undoAction->setIcon(QIcon(":/icons/img/edit-undo.png"));
    undoAction->setShortcut(QKeySequence::Undo);
    ui->mainToolBar->addAction(undoAction);
    editMenu->addAction(undoAction);

    QAction *redoAction = _undoStack.createRedoAction(this, "&Redo");
    redoAction->setIcon(QIcon(":/icons/img/edit-redo.png"));
    redoAction->setShortcut(QKeySequence::Redo);
    ui->mainToolBar->addAction(redoAction);
    editMenu->addAction(redoAction);

    /*QMenu *viewMenu = */ui->menuBar->addMenu("&View");
    /*QMenu *helpMenu = */ui->menuBar->addMenu("&Help");
}

void MainWindow::configNode()
{
    ConfigNodeDialog configNodeDialog(this);
    configNodeDialog.setProject(_project);
    configNodeDialog.exec();
}

void MainWindow::moveBlock(ModelBlock *block, QPoint oldPos, QPoint newPos)
{
    _undoStack.push(new BlockCmdMove(block, oldPos, newPos));
}
