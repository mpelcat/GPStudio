#include "blockeditorwindow.h"

#include <QLayout>
#include <QSplitter>
#include <QDebug>

BlockEditorWindow::BlockEditorWindow(QWidget *parent, const ModelBlock *block)
    : QMainWindow(parent)
{
    setupWidgets();
    setMinimumWidth(800);
    setMinimumHeight(600);

    setBlock(block);
}

void BlockEditorWindow::openFile(const QModelIndex &indexFile)
{
    QStandardItem *item = _filesModel.itemFromIndex(indexFile);
    if(!item)
        return;

    _codeEditor->clear();
    foreach (ModelFile *file, _block->files())
    {
        if(file->name() == item->text())
        {
            _codeEditor->loadFileCode(file->path());
            break;
        }
    }
}

void BlockEditorWindow::setupWidgets()
{
    QWidget *centralwidget;
    centralwidget = new QWidget(this);

    QLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);

    QSplitter *splitter = new QSplitter();
    splitter->setOrientation(Qt::Horizontal);
    layout->addWidget(splitter);

    _filesTreeView = new QTreeView(this);
    _filesTreeView->setModel(&_filesModel);
    splitter->addWidget(_filesTreeView);

    _codeEditor = new CodeEditor(this);
    splitter->addWidget(_codeEditor);

    centralwidget->setLayout(layout);
    setCentralWidget(centralwidget);

    splitter->setStretchFactor(0, QSizePolicy::Fixed);
    splitter->setStretchFactor(1, QSizePolicy::Maximum);
}

void BlockEditorWindow::setBlock(const ModelBlock *block)
{
    if(!block)
        return;
    _block = block;

    setWindowTitle(QString("gpblock | %1").arg(_block->driver()));

    QStandardItem *rootBlockItem = new QStandardItem(_block->driver());
    rootBlockItem->setEditable(false);
    _filesModel.invisibleRootItem()->appendRow(rootBlockItem);

    foreach (ModelFile *file, _block->files())
    {
        QStandardItem *item = new QStandardItem(file->name());
        item->setEditable(false);
        rootBlockItem->appendRow(item);
        connect(_filesTreeView, SIGNAL(doubleClicked(QModelIndex)), this, SLOT(openFile(QModelIndex)));
    }

    _filesTreeView->expandAll();
}
