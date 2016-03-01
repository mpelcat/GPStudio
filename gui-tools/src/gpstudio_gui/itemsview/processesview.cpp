#include "processesview.h"

#include <QDebug>
#include <QMouseEvent>
#include <QMimeData>

#include "processitem.h"
#include "processconnectoritem.h"

ProcessesView::ProcessesView(QWidget *parent)
    : QGraphicsView(parent)
{
    _lib = NULL;
    _scene = new ProcessesScene();

    _startConnectItem = NULL;
    _lineConector = NULL;

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
    QString blockType = event->mimeData()->text();
    ProcessItem *proc = new ProcessItem(_lib->process(blockType));
    proc->setPos(mapToScene(event->pos()));
    proc->setName(blockType);
    _scene->addItem(proc);
}

void ProcessesView::mousePressEvent(QMouseEvent *event)
{
    QGraphicsView::mousePressEvent(event);

    if(event->button() == Qt::RightButton)
    {
        ProcessItem *processItem = qgraphicsitem_cast<ProcessItem*>(itemAt(event->pos()));
        if(processItem)
        {
            _startConnectItem = processItem;
            _lineConector = new QGraphicsLineItem();
            _lineConector->setLine(QLineF(mapToScene(event->pos()), mapToScene(event->pos())));
            scene()->addItem(_lineConector);
        }
    }
}

void ProcessesView::mouseMoveEvent(QMouseEvent *event)
{
    QGraphicsView::mouseMoveEvent(event);

    if(_startConnectItem)
    {
        QLineF line = _lineConector->line();
        line.setP2(mapToScene(event->pos()-QPoint(-5,-5)));
        _lineConector->setLine(line);
    }
}

void ProcessesView::mouseReleaseEvent(QMouseEvent *event)
{
    QGraphicsView::mouseReleaseEvent(event);

    if(_startConnectItem)
    {
        ProcessItem *processItem = qgraphicsitem_cast<ProcessItem*>(itemAt(event->pos()));
        if(processItem)
        {
            ProcessConnectorItem *connectItem = new ProcessConnectorItem(_startConnectItem, processItem);
            scene()->addItem(connectItem);
            _startConnectItem->addConnect(connectItem);
            processItem->addConnect(connectItem);
        }

        scene()->removeItem(_lineConector);
        _startConnectItem = NULL;
        _lineConector = NULL;
    }
}

Lib *ProcessesView::lib() const
{
    return _lib;
}

void ProcessesView::setLib(Lib *lib)
{
    _lib = lib;
}

bool ProcessesView::loadFromNode(ModelNode *node)
{
    _scene->clear();
    if(_lib==NULL) return false;

    foreach (ModelBlock *block, node->blocks())
    {
        if(block->type()=="io")
        {
            IOLib *ioLib = _lib->io(block->driver());
            if(ioLib)
            {
                ProcessItem *proc = new ProcessItem(ioLib);
                proc->setName(block->name());
                proc->setPos(block->xPos(), block->yPos());
                _scene->addItem(proc);
            }
        }
        if(block->type()=="process")
        {
            ProcessLib *processLib = _lib->process(block->driver());
            if(processLib)
            {
                ProcessItem *proc = new ProcessItem(processLib);
                proc->setName(block->name());
                proc->setPos(block->xPos(), block->yPos());
                _scene->addItem(proc);
            }
        }
    }

    return true;
}
