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

#include "blockview.h"

#include <QDebug>
#include <QMouseEvent>
#include <QMimeData>

#include "blockitem.h"
#include "blockconnectoritem.h"

BlockView::BlockView(QWidget *parent)
    : QGraphicsView(parent)
{
    _lib = NULL;
    _scene = new BlockScene();

    _startConnectItem = NULL;
    _lineConector = NULL;

    setScene(_scene);

    setAcceptDrops(true);
}

BlockView::~BlockView()
{
}

void BlockView::dragEnterEvent(QDragEnterEvent *event)
{
    event->accept();
}

void BlockView::dragMoveEvent(QDragMoveEvent *event)
{
    event->accept();
}

void BlockView::dropEvent(QDropEvent *event)
{
    if(!_lib) return;
    QString blockType = event->mimeData()->text();
    BlockItem *proc = new BlockItem(_lib->process(blockType));
    proc->setPos(mapToScene(event->pos()));
    proc->setName(blockType);
    _scene->addItem(proc);
}

void BlockView::mousePressEvent(QMouseEvent *event)
{
    QGraphicsView::mousePressEvent(event);

    if(event->button() == Qt::RightButton)
    {
        BlockItem *processItem = qgraphicsitem_cast<BlockItem*>(itemAt(event->pos()));
        if(processItem)
        {
            _startConnectItem = processItem;
            _lineConector = new QGraphicsLineItem();
            _lineConector->setLine(QLineF(mapToScene(event->pos()), mapToScene(event->pos())));
            scene()->addItem(_lineConector);
        }
    }
}

void BlockView::mouseMoveEvent(QMouseEvent *event)
{
    QGraphicsView::mouseMoveEvent(event);

    if(_startConnectItem)
    {
        QLineF line = _lineConector->line();
        line.setP2(mapToScene(event->pos()-QPoint(-5,-5)));
        _lineConector->setLine(line);
    }
}

void BlockView::mouseReleaseEvent(QMouseEvent *event)
{
    QGraphicsView::mouseReleaseEvent(event);

    if(_startConnectItem)
    {
        BlockItem *processItem = qgraphicsitem_cast<BlockItem*>(itemAt(event->pos()));
        if(processItem)
        {
            BlockConnectorItem *connectItem = new BlockConnectorItem(_startConnectItem, processItem);
            scene()->addItem(connectItem);
            _startConnectItem->addConnect(connectItem);
            processItem->addConnect(connectItem);
        }

        scene()->removeItem(_lineConector);
        _startConnectItem = NULL;
        _lineConector = NULL;
    }
}

Lib *BlockView::lib() const
{
    return _lib;
}

void BlockView::setLib(Lib *lib)
{
    _lib = lib;
}

bool BlockView::loadFromNode(const ModelNode *node)
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
                BlockItem *proc = new BlockItem(ioLib);
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
                BlockItem *proc = new BlockItem(processLib);
                proc->setName(block->name());
                proc->setPos(block->xPos(), block->yPos());
                _scene->addItem(proc);
            }
        }
    }

    return true;
}
