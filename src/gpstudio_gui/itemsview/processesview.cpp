#include "processesview.h"

#include <QDebug>
#include <QMouseEvent>

#include "processitem.h"

ProcessesView::ProcessesView(QWidget *parent)
    : QGraphicsView(parent)
{
    _scene = new ProcessesScene();
    setScene(_scene);

    setAcceptDrops(true);
}

ProcessesView::~ProcessesView()
{
}

void ProcessesView::dragEnterEvent(QDragEnterEvent *event)
{
    event->accept();
}

void ProcessesView::dragMoveEvent(QDragMoveEvent *event)
{
    event->accept();
}

void ProcessesView::dropEvent(QDropEvent *event)
{
    if(!_lib) return;
    ProcessItem *proc = new ProcessItem(_lib->process(event->mimeData()->text()));
    proc->setPos(mapToScene(event->pos()));
    _scene->addItem(proc);
}

Lib *ProcessesView::lib() const
{
    return _lib;
}

void ProcessesView::setLib(Lib *lib)
{
    _lib = lib;
}
