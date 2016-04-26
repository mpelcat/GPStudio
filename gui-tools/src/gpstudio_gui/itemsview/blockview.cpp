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
    _scene = new BlockScene();
    scale(0.75, 0.75);

    _startConnectItem = NULL;
    _lineConector = NULL;

    setScene(_scene);

    setAcceptDrops(true);
    setRenderHint(QPainter::Antialiasing, true);
    setRenderHint(QPainter::SmoothPixmapTransform, true);
    setRenderHint(QPainter::TextAntialiasing, true);

    setDragMode(QGraphicsView::ScrollHandDrag);

    connect(_scene, SIGNAL(selectionChanged()), this, SLOT(updateSelection()));
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
    QString blockType = event->mimeData()->text();
    BlockItem *proc = BlockItem::fromProcessLib(Lib::getLib().process(blockType));
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
            blockScene()->addItem(_lineConector);
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

    /*if(_startConnectItem)
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
    }*/
}

void BlockView::updateSelection()
{
    if(_scene->selectedItems().count()==0)
        return;

    QGraphicsItem *item = _scene->selectedItems().at(0);
    BlockItem *blockItem = qgraphicsitem_cast<BlockItem *>(item);
    if(blockItem)
    {
        emit blockSelected(blockItem->block());
    }
}

void BlockView::setBlockScene(BlockScene *scene)
{
    _scene = scene;
    setScene(scene);
}

BlockScene *BlockView::blockScene() const
{
    return _scene;
}

bool BlockView::loadFromNode(const ModelNode *node)
{
    return _scene->loadFromNode(node);
}

bool BlockView::loadFromCam(const Camera *camera)
{
    return _scene->loadFromCamera(camera);
}
