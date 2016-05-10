#include "blockeditorwindow.h"

#include <QLayout>
#include <QSplitter>
#include <QDebug>
#include <QMenu>
#include <QMenuBar>
#include <QToolBar>

BlockEditorWindow::BlockEditorWindow(QWidget *parent, const ModelBlock *block)
    : QMainWindow(parent)
{
    _filesModel = new QStandardItemModel();
    setupWidgets();
    createToolBarAndMenu();

    setMinimumWidth(800);
    setMinimumHeight(600);

    setBlock(block);
}

BlockEditorWindow::~BlockEditorWindow()
{
    //delete menuBar();
    //delete layout();
}

void BlockEditorWindow::openFile(const QModelIndex &indexFile)
{
    QStandardItem *item = _filesModel->itemFromIndex(indexFile);
    if(!item)
        return;

    ModelFile *file = _block->getFile(item->text());
    if(file)
    {
        for(int i=0; i<_tabFiles->count(); i++)
        {
            if(_tabFiles->tabText(i)==file->name())
            {
                _tabFiles->setCurrentIndex(i);
                return;
            }
        }

        CodeEditor *codeEditor = new CodeEditor(this);
        _tabFiles->addTab(codeEditor, file->name());
        _tabFiles->setCurrentIndex(_tabFiles->count()-1);
        codeEditor->loadFileCode(file->path());
    }
}

void BlockEditorWindow::setupWidgets()
{
    QWidget *centralwidget = new QWidget(this);

    QLayout *layout = new QVBoxLayout(centralwidget);
    layout->setContentsMargins(0,0,0,0);

    QSplitter *splitter = new QSplitter(centralwidget);
    splitter->setOrientation(Qt::Horizontal);
    layout->addWidget(splitter);

    _filesTreeView = new QTreeView(splitter);
    _filesTreeView->setModel(_filesModel);
    splitter->addWidget(_filesTreeView);

    _tabFiles = new QTabWidget(splitter);
    _tabFiles->setTabsClosable(true);
    splitter->addWidget(_tabFiles);

    centralwidget->setLayout(layout);
    setCentralWidget(centralwidget);

    QMenuBar *menubar = new QMenuBar(this);
    setMenuBar(menubar);

    splitter->setStretchFactor(0, QSizePolicy::Fixed);
    splitter->setStretchFactor(1, QSizePolicy::Maximum);
}

void BlockEditorWindow::createToolBarAndMenu()
{
    _mainToolBar = new QToolBar(this);
    addToolBar(_mainToolBar);

    // ============= File =============
    QMenu *nodeMenu = menuBar()->addMenu("&Node");

    QAction *openDocAction = new QAction("&Open block",this);
    openDocAction->setIcon(QIcon(":/icons/img/open.png"));
    openDocAction->setShortcut(QKeySequence::Open);
    _mainToolBar->addAction(openDocAction);
    nodeMenu->addAction(openDocAction);

    QAction *connectAction = new QAction("&Save block",this);
    connectAction->setIcon(QIcon(":/icons/img/save.png"));
    openDocAction->setShortcut(QKeySequence::Save);
    _mainToolBar->addAction(connectAction);
    nodeMenu->addAction(connectAction);

    // ============= View =============
    QMenu *viewMenu = menuBar()->addMenu("&View");

    viewMenu->addSeparator();

    // ============= Help =============
    /*QMenu *helpMenu =*/ menuBar()->addMenu("&Help");

    _mainToolBar->addSeparator();
}

void BlockEditorWindow::setBlock(const ModelBlock *block)
{
    if(!block)
        return;
    _block = block;

    setWindowTitle(QString("gpblock | %1").arg(_block->driver()));

    QStandardItem *rootBlockItem = new QStandardItem(_block->driver());
    rootBlockItem->setEditable(false);
    _filesModel->invisibleRootItem()->appendRow(rootBlockItem);

    foreach (ModelFile *file, _block->files())
    {
        QStandardItem *item = new QStandardItem(file->name());
        item->setEditable(false);
        rootBlockItem->appendRow(item);
    }
    connect(_filesTreeView, SIGNAL(doubleClicked(QModelIndex)), this, SLOT(openFile(QModelIndex)));

    _filesTreeView->expandAll();
}
