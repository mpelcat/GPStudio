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
#include <QMessageBox>

#include "propertywidgets/propertywidgets.h"

#include "undostack/blockcommands.h"

NodeEditorWindows::NodeEditorWindows(QWidget *parent, GPNodeProject *nodeProject) :
    QMainWindow(parent)
{
    setWindowIcon(QIcon(":/img/img/gpstudio_node.ico"));

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

    _blockEditor = NULL;
    showCamExplorer();
}

NodeEditorWindows::~NodeEditorWindows()
{
    delete _camExplorerWidget;
    delete _libTreeView;
    delete _compileLog;
    delete _project;
}

void NodeEditorWindows::attachProject(GPNodeProject *project)
{
    /*if(_project)
        disconnect(_project);*/

    _project = project;
    _project->setNodeEditorWindow(this);

    connect(_project, SIGNAL(nodeChanged(ModelNode *)), this, SLOT(reloadNode()));
    connect(_project, SIGNAL(nodePathChanged(QString)), this, SLOT(reloadNodePath()));

    connect(_blocksView, SIGNAL(blockSelected(QString)), _camExplorerWidget, SLOT(selectBlock(QString)));
    connect(_camExplorerWidget, SIGNAL(blockSelected(QString)), _blocksView, SLOT(selectBlock(QString)));
    connect(_blocksView, SIGNAL(blockSelected(QString)), this, SLOT(showCamExplorer()));

    connect(_blocksView, SIGNAL(blockDetailsRequest(QString)), this, SLOT(showBlockDetails(QString)));

    // attach project to editors and viewers
    _camExplorerWidget->attachProject(_project);
    _viewerExplorerWidget->attachProject(_project);
    _blocksView->attachProject(_project);
    _compileLog->setProject(_project);
    _libTreeView->attachProject(_project);

    if(project->node())
    {
        reloadNode();
        reloadNodePath();
    }
}

void NodeEditorWindows::closeEvent(QCloseEvent *event)
{
    if(_project->closeProject())
        event->accept();
    else
        event->ignore();
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

    // cam explorer dock
    _camExplorerDock = new QDockWidget("Node project explorer", this);
    QWidget *camExplorerContent = new QWidget(_camExplorerDock);
    QLayout *camExplorerLayout = new QVBoxLayout();
    _camExplorerWidget = new CamExplorerWidget();
    camExplorerLayout->addWidget(_camExplorerWidget);
    camExplorerContent->setLayout(camExplorerLayout);
    _camExplorerDock->setWidget(camExplorerContent);
    addDockWidget(Qt::LeftDockWidgetArea, _camExplorerDock);

    // viewer explorer dock
    _viewerExplorerDock = new QDockWidget("Viewers", this);
    QWidget *viewerExplorerContent = new QWidget(_viewerExplorerDock);
    QLayout *viewerExplorerLayout = new QVBoxLayout();
    _viewerExplorerWidget = new ViewerExplorerWidget();
    viewerExplorerLayout->addWidget(_viewerExplorerWidget);
    viewerExplorerContent->setLayout(viewerExplorerLayout);
    _viewerExplorerDock->setWidget(viewerExplorerContent);
    tabifyDockWidget(_camExplorerDock, _viewerExplorerDock);

    // lib treeview dock
    _libTreeViewDock = new QDockWidget("IP library explorer", this);
    QWidget *libTreeViewContent = new QWidget(_libTreeViewDock);
    QLayout *libTreeViewLayout = new QVBoxLayout();
    _libTreeView = new LibTreeView();
    _libTreeView->setLib(&Lib::getLib());
    libTreeViewLayout->addWidget(_libTreeView);
    libTreeViewContent->setLayout(libTreeViewLayout);
    _libTreeViewDock->setWidget(libTreeViewContent);
    addDockWidget(Qt::RightDockWidgetArea, _libTreeViewDock);

    // compile log dock
    _compileLogDock = new QDockWidget("Compilation log", this);
    QWidget *compileLogContent = new QWidget(_compileLogDock);
    QLayout *compileLogLayout = new QVBoxLayout();
    _compileLog = new CompileLogWidget();
    compileLogLayout->addWidget(_compileLog);
    compileLogContent->setLayout(compileLogLayout);
    _compileLogDock->setWidget(compileLogContent);
    addDockWidget(Qt::BottomDockWidgetArea, _compileLogDock);
}

void NodeEditorWindows::createToolBarAndMenu()
{
    _mainToolBar = new QToolBar(this);
    addToolBar(_mainToolBar);

    // ============= Node =============
    QMenu *nodeMenu = menuBar()->addMenu("&Node");

    QAction *newDocAction = new QAction("&New",this);
    newDocAction->setStatusTip("Creates a new node project");
    newDocAction->setIcon(QIcon(":/icons/img/new.png"));
    newDocAction->setShortcut(QKeySequence::New);
    _mainToolBar->addAction(newDocAction);
    nodeMenu->addAction(newDocAction);
    connect(newDocAction, SIGNAL(triggered(bool)), _project, SLOT(newProject()));
    connect(newDocAction, SIGNAL(triggered(bool)), _compileLog, SLOT(clear()));

    QAction *openDocAction = new QAction("&Open",this);
    openDocAction->setStatusTip("Opens a node project");
    openDocAction->setIcon(QIcon(":/icons/img/open.png"));
    openDocAction->setShortcut(QKeySequence::Open);
    _mainToolBar->addAction(openDocAction);
    nodeMenu->addAction(openDocAction);
    connect(openDocAction, SIGNAL(triggered(bool)), _project, SLOT(openProject()));

    QAction *saveDocAction = new QAction("&Save",this);
    saveDocAction->setStatusTip("Saves the current node project");
    saveDocAction->setIcon(QIcon(":/icons/img/save.png"));
    saveDocAction->setShortcut(QKeySequence::Save);
    saveDocAction->setEnabled(false);
    _mainToolBar->addAction(saveDocAction);
    nodeMenu->addAction(saveDocAction);
    connect(saveDocAction, SIGNAL(triggered(bool)), _project, SLOT(saveProject()));
    connect(_project, SIGNAL(nodeModified(bool)), saveDocAction, SLOT(setEnabled(bool)));

    QAction *saveDocAsAction = new QAction("Save &as...",this);
    saveDocAsAction->setStatusTip("Saves the current node project with a new name");
    saveDocAsAction->setIcon(QIcon(":/icons/img/save.png"));
    saveDocAsAction->setShortcut(QKeySequence::SaveAs);
    nodeMenu->addAction(saveDocAsAction);
    connect(saveDocAsAction, SIGNAL(triggered(bool)), _project, SLOT(saveProjectAs()));

    nodeMenu->addSeparator();
    _mainToolBar->addSeparator();

    QAction *configNode = new QAction("&Configure node",this);
    configNode->setStatusTip("Permits to choose the targeted platform and to choose associated periphericals");
    configNode->setIcon(QIcon(":/icons/img/settings.png"));
    configNode->setShortcut(QKeySequence::Preferences);
    nodeMenu->addAction(configNode);
    _mainToolBar->addAction(configNode);
    connect(configNode, SIGNAL(triggered()), this, SLOT(configNode()));

    nodeMenu->addSeparator();
    QAction *exit = new QAction("E&xit",this);
    exit->setStatusTip("Exits GPNode");
    exit->setIcon(QIcon(":/icons/img/exit.png"));
    exit->setShortcut(QKeySequence::Quit);
    nodeMenu->addAction(exit);
    connect(exit, SIGNAL(triggered()), this, SLOT(close()));

    // ============= Edit =============
    QMenu *editMenu = menuBar()->addMenu("&Edit");
    _mainToolBar->addSeparator();

    QAction *undoAction = _project->undoStack()->createUndoAction(this, "&Undo");
    undoAction->setStatusTip("Undo the latest action");
    undoAction->setIcon(QIcon(":/icons/img/edit-undo.png"));
    undoAction->setShortcut(QKeySequence::Undo);
    _mainToolBar->addAction(undoAction);
    editMenu->addAction(undoAction);

    QAction *redoAction = _project->undoStack()->createRedoAction(this, "&Redo");
    redoAction->setStatusTip("Redo the latest action");
    redoAction->setIcon(QIcon(":/icons/img/edit-redo.png"));
    redoAction->setShortcut(QKeySequence::Redo);
    _mainToolBar->addAction(redoAction);
    editMenu->addAction(redoAction);

    // ============= View =============
    QMenu *viewMenu = menuBar()->addMenu("&View");

    viewMenu->addSeparator();
    QAction *viewLibAction = _libTreeViewDock->toggleViewAction();
    viewLibAction->setStatusTip("Shows or hide the IP library explorer");
    viewMenu->addAction(viewLibAction);

    QAction *viewCamexAction = _camExplorerDock->toggleViewAction();
    viewCamexAction->setStatusTip("Shows or hide the camera explorer");
    viewMenu->addAction(viewCamexAction);

    QAction *viewExplorerDock = _viewerExplorerDock->toggleViewAction();
    viewExplorerDock->setStatusTip("Shows or hide the camera explorer");
    viewMenu->addAction(viewExplorerDock);

    QAction *viewLogAction = _compileLogDock->toggleViewAction();
    viewLogAction->setStatusTip("Shows or hide the compilation log");
    viewMenu->addAction(viewLogAction);

    // ============= Project =============
    QMenu *projectMenu = menuBar()->addMenu("&Project");
    _mainToolBar->addSeparator();

    QAction *makecleanAction = new QAction("&Clean project", this);
    makecleanAction->setStatusTip("Removes all intermediary files");
    makecleanAction->setIcon(QIcon(":/icons/img/make-clean.png"));
    connect(makecleanAction, SIGNAL(triggered(bool)), _compileLog, SLOT(launchClean()));
    connect(_compileLog, SIGNAL(cleanAvailable(bool)), makecleanAction, SLOT(setEnabled(bool)));
    _mainToolBar->addAction(makecleanAction);
    projectMenu->addAction(makecleanAction);

    QAction *makegenerateAction = new QAction("&Generate project", this);
    makegenerateAction->setStatusTip("Generate a synthetisable project");
    makegenerateAction->setIcon(QIcon(":/icons/img/make-generate.png"));
    connect(makegenerateAction, SIGNAL(triggered(bool)), _compileLog, SLOT(launchGenerate()));
    connect(_compileLog, SIGNAL(generateAvailable(bool)), makegenerateAction, SLOT(setEnabled(bool)));
    _mainToolBar->addAction(makegenerateAction);
    projectMenu->addAction(makegenerateAction);

    QAction *makecompileAction = new QAction("Comp&ile project", this);
    makecompileAction->setStatusTip("Synthetises the HDL project");
    makecompileAction->setIcon(QIcon(":/icons/img/make-compile.png"));
    connect(makecompileAction, SIGNAL(triggered(bool)), _compileLog, SLOT(launchCompile()));
    connect(_compileLog, SIGNAL(compileAvailable(bool)), makecompileAction, SLOT(setEnabled(bool)));
    _mainToolBar->addAction(makecompileAction);
    projectMenu->addAction(makecompileAction);

    QAction *makesendAction = new QAction("&Program camera", this);
    makesendAction->setStatusTip("Programs your camera");
    makesendAction->setIcon(QIcon(":/icons/img/make-send.png"));
    connect(makesendAction, SIGNAL(triggered(bool)), _compileLog, SLOT(launchSend()));
    connect(_compileLog, SIGNAL(sendAvailable(bool)), makesendAction, SLOT(setEnabled(bool)));
    _mainToolBar->addAction(makesendAction);
    projectMenu->addAction(makesendAction);

    QAction *makerunAction = new QAction("&Launch camera with viewer", this);
    makerunAction->setStatusTip("Launch your project on your camera with GPViewer");
    makerunAction->setIcon(QIcon(":/icons/img/run.png"));
    connect(makerunAction, SIGNAL(triggered(bool)), _compileLog, SLOT(launchView()));
    connect(_compileLog, SIGNAL(runAvailable(bool)), makerunAction, SLOT(setEnabled(bool)));
    _mainToolBar->addAction(makerunAction);
    projectMenu->addAction(makerunAction);

    QAction *makeallAction = new QAction("&All previous action", this);
    makeallAction->setStatusTip("Generate, compile and lauch your projects");
    makeallAction->setIcon(QIcon(":/icons/img/make-all.png"));
    connect(makeallAction, SIGNAL(triggered(bool)), _compileLog, SLOT(launchAll()));
    connect(_compileLog, SIGNAL(generateAvailable(bool)), makeallAction, SLOT(setEnabled(bool)));
    _mainToolBar->addAction(makeallAction);
    projectMenu->addAction(makeallAction);

    QAction *stopAction = new QAction("&Abort command", this);
    stopAction->setStatusTip("Aborts current launched command");
    stopAction->setIcon(QIcon(":/icons/img/stop.png"));
    stopAction->setEnabled(false);
    connect(stopAction, SIGNAL(triggered(bool)), _compileLog, SLOT(stopAll()));
    connect(_compileLog, SIGNAL(stopAvailable(bool)), stopAction, SLOT(setEnabled(bool)));
    _mainToolBar->addAction(stopAction);
    projectMenu->addAction(stopAction);

    // ============= Help =============
    QMenu *helpMenu = menuBar()->addMenu("&Help");

    QAction *aboutAction = new QAction("&About", this);
    aboutAction->setStatusTip("Shows abou");
    connect(aboutAction, SIGNAL(triggered(bool)), this, SLOT(about()));
    helpMenu->addAction(aboutAction);

    QAction *aboutQtAction = new QAction("About &Qt", this);
    aboutQtAction->setStatusTip("About Qt version");
    connect(aboutQtAction, SIGNAL(triggered(bool)), this, SLOT(aboutQt()));
    helpMenu->addAction(aboutQtAction);
}

void NodeEditorWindows::configNode()
{
    _project->configBoard();
}

void NodeEditorWindows::addProcess(QString driver)
{
    _project->addBlock(driver, QPoint(0, 0));
}

void NodeEditorWindows::reloadNode()
{
    reloadNodePath();
}

void NodeEditorWindows::reloadNodePath()
{
    setWindowTitle(QString("GPnode - %1").arg(_project->name()));
}

void NodeEditorWindows::about()
{
    QMessageBox::about(this,"GPStudio: GPNode 1.10","Copyright (C) 2016 Dream IP\n\
\n\
This sofware is part of GPStudio.\n\
\n\
GPStudio is a free software: you can redistribute it and/or modify\n\
it under the terms of the GNU General Public License as published by\n\
the Free Software Foundation, either version 3 of the License, or\n\
(at your option) any later version.\n\
\n\
This program is distributed in the hope that it will be useful,\n\
but WITHOUT ANY WARRANTY; without even the implied warranty of\n\
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n\
GNU General Public License for more details.\n\
\n\
You should have received a copy of the GNU General Public License\n\
along with this program.  If not, see <http://www.gnu.org/licenses/>\n.");
}

void NodeEditorWindows::aboutQt()
{
    QMessageBox::aboutQt(this);
}

void NodeEditorWindows::showBlockDetails(QString blockName)
{
    if(blockName.isEmpty())
        return;
    if(_blockEditor)
        delete _blockEditor;
    _blockEditor = NULL;
    ModelBlock *block = _project->node()->getBlock(blockName);
    if(block)
    {
        _blockEditor = new BlockEditorWindow (this, block);
        _blockEditor->show();
    }
}

void NodeEditorWindows::showCamExplorer()
{
    _camExplorerDock->show();
    _camExplorerDock->raise();
}
