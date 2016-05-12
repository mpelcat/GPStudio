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

#include "nodeeditorwindows.h"

#include "model/model_node.h"
#include "model/model_parambitfield.h"

#include <QDebug>
#include <QFile>

#include <QStatusBar>
#include <QToolBar>
#include <QMenuBar>
#include <QAction>
#include <QDockWidget>
#include <QLayout>

#include "propertywidgets/propertywidgets.h"

#include "confignodedialog.h"

#include "undostack/blockcommands.h"

NodeEditorWindows::NodeEditorWindows(QWidget *parent, GPNodeProject *nodeProject) :
    QMainWindow(parent)
{
    setupWidgets();
    createDocks();
    createToolBarAndMenu();

    if(nodeProject)
        _project = nodeProject;
    else
        _project = new GPNodeProject();

    _blocksView->loadFromNode(nodeProject->node());

    connect(_blocksView, SIGNAL(blockMoved(ModelBlock*,QPoint,QPoint)),
            this, SLOT(moveBlock(ModelBlock*,QPoint,QPoint)));
}

NodeEditorWindows::~NodeEditorWindows()
{
    delete _project;
}

void NodeEditorWindows::setupWidgets()
{
    QWidget *centralwidget = new QWidget(this);

    QLayout *layout = new QVBoxLayout(centralwidget);

    _blocksView = new BlockView(centralwidget);
    _blocksView->setEditMode(true);
    layout->addWidget(_blocksView);

    centralwidget->setLayout(layout);
    setCentralWidget(centralwidget);

    QMenuBar *menubar = new QMenuBar(this);
    setMenuBar(menubar);

    QStatusBar *statusBar = new QStatusBar(this);
    setStatusBar(statusBar);

    setGeometry(100, 100, 800, 600);
}

void NodeEditorWindows::createDocks()
{
    // settings of mdi area
    setCorner(Qt::TopLeftCorner, Qt::LeftDockWidgetArea);
    setCorner(Qt::BottomLeftCorner, Qt::LeftDockWidgetArea);
    setTabPosition(Qt::LeftDockWidgetArea, QTabWidget::North);

    // lib treeview dock
    _libTreeView = new LibTreeView();
    _libTreeView->setLib(&Lib::getLib());

    _libTreeViewDock = new QDockWidget("LibExplorer", this);
    QWidget *libTreeViewContent = new QWidget(_libTreeViewDock);
    QLayout *libTreeViewLayout = new QVBoxLayout();
    _libTreeView = new LibTreeView();
    _libTreeView->setLib(&Lib::getLib());
    libTreeViewLayout->addWidget(_libTreeView);
    libTreeViewContent->setLayout(libTreeViewLayout);
    _libTreeViewDock->setWidget(libTreeViewContent);
    addDockWidget(Qt::LeftDockWidgetArea, _libTreeViewDock);
}

void NodeEditorWindows::createToolBarAndMenu()
{
    _mainToolBar = new QToolBar(this);
    addToolBar(_mainToolBar);

    // ============= Node =============
    QMenu *nodeMenu = menuBar()->addMenu("&Node");

    QAction *newDocAction = new QAction("&New",this);
    newDocAction->setIcon(QIcon(":/icons/img/new.png"));
    newDocAction->setShortcut(QKeySequence::New);
    _mainToolBar->addAction(newDocAction);
    nodeMenu->addAction(newDocAction);

    QAction *openDocAction = new QAction("&Open",this);
    openDocAction->setIcon(QIcon(":/icons/img/open.png"));
    openDocAction->setShortcut(QKeySequence::Open);
    _mainToolBar->addAction(openDocAction);
    nodeMenu->addAction(openDocAction);

    QAction *saveDocAction = new QAction("&Save",this);
    saveDocAction->setIcon(QIcon(":/icons/img/save.png"));
    saveDocAction->setShortcut(QKeySequence::Save);
    _mainToolBar->addAction(saveDocAction);
    nodeMenu->addAction(saveDocAction);

    nodeMenu->addSeparator();
    _mainToolBar->addSeparator();

    QAction *configNode = new QAction("&Configure node",this);
    configNode->setIcon(QIcon(":/icons/img/settings.png"));
    saveDocAction->setShortcut(QKeySequence::Preferences);
    nodeMenu->addAction(configNode);
    _mainToolBar->addAction(configNode);
    connect(configNode, SIGNAL(triggered()), this, SLOT(configNode()));

    // ============= Edit =============
    QMenu *editMenu = menuBar()->addMenu("&Edit");
    _mainToolBar->addSeparator();

    QAction *undoAction = _undoStack.createUndoAction(this, "&Undo");
    undoAction->setIcon(QIcon(":/icons/img/edit-undo.png"));
    undoAction->setShortcut(QKeySequence::Undo);
    _mainToolBar->addAction(undoAction);
    editMenu->addAction(undoAction);

    QAction *redoAction = _undoStack.createRedoAction(this, "&Redo");
    redoAction->setIcon(QIcon(":/icons/img/edit-redo.png"));
    redoAction->setShortcut(QKeySequence::Redo);
    _mainToolBar->addAction(redoAction);
    editMenu->addAction(redoAction);

    /*QMenu *viewMenu = */menuBar()->addMenu("&View");
    /*QMenu *helpMenu = */menuBar()->addMenu("&Help");
}

void NodeEditorWindows::configNode()
{
    ConfigNodeDialog configNodeDialog(this);
    configNodeDialog.setProject(_project);
    configNodeDialog.exec();
}

void NodeEditorWindows::moveBlock(ModelBlock *block, QPoint oldPos, QPoint newPos)
{
    _undoStack.push(new BlockCmdMove(block, oldPos, newPos));
}
