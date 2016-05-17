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
#include <qmath.h>

#include "blockitem.h"
#include "blockconnectoritem.h"

BlockView::BlockView(QWidget *parent)
    : QGraphicsView(parent)
{
    _project = NULL;
    _editMode = false;
    _scene = new BlockScene();
    scale(0.75, 0.75);

    _startConnectItem = NULL;
    _lineConector = NULL;

    setScene(_scene);

    setAcceptDrops(true);
    setResizeAnchor(QGraphicsView::AnchorUnderMouse);
    setTransformationAnchor(QGraphicsView::AnchorUnderMouse);
    setRenderHint(QPainter::Antialiasing, true);
    setRenderHint(QPainter::SmoothPixmapTransform, true);
    setRenderHint(QPainter::TextAntialiasing, true);

    setDragMode(QGraphicsView::ScrollHandDrag);

    connect(_scene, SIGNAL(selectionChanged()), this, SLOT(updateSelection()));
}

BlockView::~BlockView()
{
}

void BlockView::attachProject(GPNodeProject *project)
{
    if(_project)
        disconnect(_project);

    _project = project;

    connect(_project, SIGNAL(nodeChanged(ModelNode*)), this, SLOT(changeNode(ModelNode*)));
    connect(_project, SIGNAL(blockUpdated(ModelBlock*)), this, SLOT(updateBlock(ModelBlock*)));

    connect(this, SIGNAL(blockMoved(ModelBlock*,QPoint,QPoint)),
            project, SLOT(moveBlock(ModelBlock*,QPoint,QPoint)));
}

void BlockView::dragEnterEvent(QDragEnterEvent *event)
{
    if(_editMode)
    {
        if(event->mimeData()->hasText())
            event->accept();
    }
}

void BlockView::dragMoveEvent(QDragMoveEvent *event)
{
    if(_editMode)
    {
        if(event->mimeData()->hasText())
            event->accept();
    }
}

void BlockView::dropEvent(QDropEvent *event)
{
    if(_editMode)
    {
        QString driver = event->mimeData()->text();
        ProcessLib *processLib = Lib::getLib().process(driver);
        if(processLib)
        {
            ModelProcess *modelProcess = new ModelProcess(*processLib->modelProcess());
            modelProcess->setName(QString("%1_%2").arg(driver).arg(1));
            modelProcess->setPos(mapToScene(event->pos()).toPoint());
            _scene->addBlock(modelProcess);
        }
    }
}

void BlockView::mousePressEvent(QMouseEvent *event)
{
    QGraphicsView::mousePressEvent(event);

    BlockItem *blockItem = qgraphicsitem_cast<BlockItem*>(itemAt(event->pos()));
    if(blockItem)
        _oldBlockPos = blockItem->pos();

    /*if(event->button() == Qt::RightButton)
    {
        BlockItem *processItem = qgraphicsitem_cast<BlockItem*>(itemAt(event->pos()));
        if(processItem)
        {
            _startConnectItem = processItem;
            _lineConector = new QGraphicsLineItem();
            _lineConector->setLine(QLineF(mapToScene(event->pos()), mapToScene(event->pos())));
            blockScene()->addItem(_lineConector);
        }
    }*/
}

void BlockView::mouseMoveEvent(QMouseEvent *event)
{
    QGraphicsView::mouseMoveEvent(event);

    /*if(_startConnectItem)
    {
        QLineF line = _lineConector->line();
        line.setP2(mapToScene(event->pos()-QPoint(-5,-5)));
        _lineConector->setLine(line);
    }*/
}

void BlockView::mouseReleaseEvent(QMouseEvent *event)
{
    QGraphicsView::mouseReleaseEvent(event);

    BlockItem *blockItem = qgraphicsitem_cast<BlockItem*>(itemAt(event->pos()));
    if(blockItem)
        if(blockItem->pos() != _oldBlockPos)
            emit blockMoved(blockItem->modelBlock(), _oldBlockPos.toPoint(), blockItem->pos().toPoint());

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

void BlockView::mouseDoubleClickEvent(QMouseEvent *event)
{
    QGraphicsView::mouseDoubleClickEvent(event);

    QGraphicsItem *item = _scene->itemAt(mapToScene(event->pos()), QTransform());
    BlockItem *blockItem = qgraphicsitem_cast<BlockItem *>(item);
    if(blockItem)
        emit blockDetailsRequest(blockItem->block());
}

void BlockView::updateSelection()
{
    if(_scene->selectedItems().count()==0)
    {
        emit blockSelected(NULL);
        return;
    }

    QGraphicsItem *item = _scene->selectedItems().at(0);
    BlockItem *blockItem = qgraphicsitem_cast<BlockItem *>(item);
    emit blockSelected(blockItem->block());
}

void BlockView::selectBlock(const Block *block)
{
    _scene->blockSignals(true);
    _scene->clearSelection();

    BlockItem *blockItem = _scene->block(block->name());
    if(blockItem)
    {
        blockItem->setSelected(true);
        blockItem->ensureVisible();
    }

    _scene->blockSignals(false);
}

void BlockView::updateBlock(ModelBlock *block)
{
    BlockItem *blockItem = _scene->block(block->name());
    if(blockItem)
    {
        blockItem->setPos(block->pos());
    }
}

void BlockView::changeNode(ModelNode *node)
{
    loadFromNode(node);
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

void BlockView::zoomIn()
{
    setZoomLevel(1);
}

void BlockView::zoomOut()
{
    setZoomLevel(-1);
}

void BlockView::zoomFit()
{
    fitInView(_scene->itemsBoundingRect(), Qt::KeepAspectRatio);
}

bool BlockView::editMode() const
{
    return _editMode;
}

void BlockView::setEditMode(bool editMode)
{
    _editMode = editMode;
}

void BlockView::setZoomLevel(int step)
{
    double zoom = qPow(1.25,step);
    scale(zoom, zoom);
}

void BlockView::wheelEvent(QWheelEvent *event)
{
    int numDegrees = event->delta() / 8;
    int numSteps = numDegrees / 15;

    setZoomLevel(numSteps);
}

void BlockView::keyPressEvent(QKeyEvent *event)
{
    if(event->key()==Qt::Key_Plus)
        zoomIn();
    if(event->key()==Qt::Key_Minus)
        zoomOut();
    if(event->key()==Qt::Key_Asterisk)
        zoomFit();
    QGraphicsView::keyPressEvent(event);
}
