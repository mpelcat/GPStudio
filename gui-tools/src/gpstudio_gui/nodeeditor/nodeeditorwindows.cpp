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
    if(nodeProject)
        _project = nodeProject;
    else
        _project = new GPNodeProject();

    setupWidgets();
    createDocks();
    createToolBarAndMenu();

    attachProject(nodeProject);
    if(!_project->node())
        _project->newProject();
}

NodeEditorWindows::~NodeEditorWindows()
{
    delete _project;
}

void NodeEditorWindows::attachProject(GPNodeProject *project)
{
    /*if(_project)
        disconnect(_project);*/

    _project = project;

    connect(_project, SIGNAL(nodeChanged(ModelNode *)), this, SLOT(reloadNode()));
    connect(_project, SIGNAL(nodePathChanged(QString)), this, SLOT(reloadNodePath()));

    if(project->node())
    {
        reloadNode();
        reloadNodePath();
    }

    // attach project to editors and viewers
    _blocksView->attachProject(_project);
}

void NodeEditorWindows::closeEvent(QCloseEvent *event)
{
    _project->closeProject();
    event->accept();
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
    connect(newDocAction, SIGNAL(triggered(bool)), _project, SLOT(newProject()));

    QAction *openDocAction = new QAction("&Open",this);
    openDocAction->setIcon(QIcon(":/icons/img/open.png"));
    openDocAction->setShortcut(QKeySequence::Open);
    _mainToolBar->addAction(openDocAction);
    nodeMenu->addAction(openDocAction);
    connect(openDocAction, SIGNAL(triggered(bool)), _project, SLOT(openProject()));

    QAction *saveDocAction = new QAction("&Save",this);
    saveDocAction->setIcon(QIcon(":/icons/img/save.png"));
    saveDocAction->setShortcut(QKeySequence::Save);
    saveDocAction->setEnabled(false);
    _mainToolBar->addAction(saveDocAction);
    nodeMenu->addAction(saveDocAction);
    connect(saveDocAction, SIGNAL(triggered(bool)), _project, SLOT(saveProject()));
    connect(_project, SIGNAL(nodeModified(bool)), saveDocAction, SLOT(setEnabled(bool)));

    QAction *saveDocAsAction = new QAction("Save &as...",this);
    saveDocAsAction->setIcon(QIcon(":/icons/img/save.png"));
    saveDocAsAction->setShortcut(QKeySequence::SaveAs);
    nodeMenu->addAction(saveDocAsAction);
    connect(saveDocAsAction, SIGNAL(triggered(bool)), _project, SLOT(saveProjectAs()));

    nodeMenu->addSeparator();
    _mainToolBar->addSeparator();

    QAction *configNode = new QAction("&Configure node",this);
    configNode->setIcon(QIcon(":/icons/img/settings.png"));
    configNode->setShortcut(QKeySequence::Preferences);
    nodeMenu->addAction(configNode);
    _mainToolBar->addAction(configNode);
    connect(configNode, SIGNAL(triggered()), this, SLOT(configNode()));

    nodeMenu->addSeparator();
    QAction *exit = new QAction("E&xit",this);
    exit->setShortcut(QKeySequence::Quit);
    nodeMenu->addAction(exit);
    connect(exit, SIGNAL(triggered()), this, SLOT(close()));

    // ============= Edit =============
    QMenu *editMenu = menuBar()->addMenu("&Edit");
    _mainToolBar->addSeparator();

    QAction *undoAction = _project->undoStack()->createUndoAction(this, "&Undo");
    undoAction->setIcon(QIcon(":/icons/img/edit-undo.png"));
    undoAction->setShortcut(QKeySequence::Undo);
    _mainToolBar->addAction(undoAction);
    editMenu->addAction(undoAction);

    QAction *redoAction = _project->undoStack()->createRedoAction(this, "&Redo");
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

void NodeEditorWindows::reloadNode()
{
    reloadNodePath();
}

void NodeEditorWindows::reloadNodePath()
{
    setWindowTitle(QString("GPnode - %1").arg(_project->name()));
}
