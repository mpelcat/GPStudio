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

#include "blockconnectoritem.h"

#include "blockportitem.h"

#include <QDebug>
#include <QPainter>
#include <QGraphicsScene>

BlockConnectorItem::BlockConnectorItem(BlockPortItem *portItemOut, BlockPortItem *portItemIn)
    : _portItem1(portItemOut), _portItem2(portItemIn)
{
    setFlag(ItemIsSelectable, true);

    if(_portItem1)
        _portItem1->addConnect(this);
    if(_portItem2)
        _portItem2->addConnect(this);
    setZValue(-2);
    //_style=LineDraw;
    _style=CubicDraw;
    updateShape(NULL);
}

BlockConnectorItem::~BlockConnectorItem()
{
}

int BlockConnectorItem::type() const
{
    return Type;
}

BlockConnectorItem::DrawStyle BlockConnectorItem::style() const
{
    return _style;
}

void BlockConnectorItem::setStyle(const BlockConnectorItem::DrawStyle &style)
{
    _style = style;
    update();
}

QRectF BlockConnectorItem::boundingRect() const
{
    return QRectF(_inPos, _outPos).normalized().adjusted(-5, -5, 5, 5);
}

QPainterPath BlockConnectorItem::shape() const
{
    QPen pen(Qt::black, 6);
    QPainterPathStroker ps;
    ps.setWidth(pen.width());
    ps.setCapStyle(pen.capStyle());
    ps.setJoinStyle(pen.joinStyle());
    ps.setMiterLimit(pen.miterLimit());
    QPainterPath p = ps.createStroke(_shape);
    p.addPath(_shape);
    return p;
}

void BlockConnectorItem::paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
{
    Q_UNUSED(option)
    Q_UNUSED(widget)

    // back draw
    painter->setPen(QPen(Qt::white, 6));
    painter->drawPath(_shape);

    // front draw
    if(isSelected())
        painter->setPen(QPen(QColor("orange"), 4));
    else
        painter->setPen(QPen(Qt::black, 3));
    painter->drawPath(_shape);
}

void BlockConnectorItem::updateShape(BlockPortItem *caller)
{
    bool inInit=false, outInit=false;
    BlockPortItem *outUpdate = NULL;
    int connectorId = 0;;

    prepareGeometryChange();

    // compute point start and end
    if(_portItem1)
    {
        if(_portItem1->direction()==BlockPortItem::Input)
        {
            _inPos = _portItem1->connectorPos(this);
            connectorId = _portItem1->connectorId(this);
            inInit = true;
        }
        else
        {
            QPointF outPos = _portItem1->connectorPos(this);
            if(outPos != _outPos && caller == _portItem1)
                outUpdate = _portItem2;
            _outPos = outPos;
            outInit = true;
        }
    }
    if(_portItem2)
    {
        if(_portItem2->direction()==BlockPortItem::Input)
        {
            _inPos = _portItem2->connectorPos(this);
            connectorId = _portItem2->connectorId(this);
            inInit = true;
        }
        else
        {
            QPointF outPos = _portItem2->connectorPos(this);
            if(outPos != _outPos && caller == _portItem2)
                outUpdate = _portItem1;
            _outPos = outPos;
            outInit = true;
        }
    }
    if(!inInit)
        _inPos = _endPos;
    if(!outInit)
        _outPos = _endPos;

    // compute shape
    QRectF rect = QRectF(_outPos, _inPos).normalized();
    int y1, y2;
    if(_outPos.y() > _inPos.y())
    {
        y1 = rect.bottom();
        y2 = rect.top();
    }
    else
    {
        y1 = rect.top();
        y2 = rect.bottom();
    }
    QPainterPath path;
    path.moveTo(_outPos);
    if(_style==LineDraw)
    {
        path.lineTo(QPoint(rect.center().x() + connectorId * 10, y1));
        path.lineTo(QPoint(rect.center().x() + connectorId * 10, y2));
        path.lineTo(_inPos);
    }
    if(_style==CubicDraw)
    {
        path.cubicTo(QPoint(rect.center().x() + connectorId * 10, y1), QPoint(rect.center().x() + connectorId * 10, y2), _inPos);
    }

    _shape = path;

    if(!_portItem1 && caller==NULL)
        _portItem2->updateShape();
    if(!_portItem2 && caller==NULL)
        _portItem1->updateShape();
    if(outUpdate)
        outUpdate->updateShape();
}

QPoint BlockConnectorItem::endPos() const
{
    return _endPos;
}

void BlockConnectorItem::setEndPos(const QPoint &endPos)
{
    _endPos = endPos;
    updateShape(NULL);
}

void BlockConnectorItem::disconnectPorts()
{
    if(_portItem1)
        _portItem1->removeConnect(this);
    if(_portItem2)
        _portItem2->removeConnect(this);
}

BlockPortItem *BlockConnectorItem::portItem1() const
{
    return _portItem1;
}

BlockPortItem *BlockConnectorItem::portItem2() const
{
    return _portItem2;
}

QPointF BlockConnectorItem::inPos() const
{
    return _inPos;
}

QPointF BlockConnectorItem::outPos() const
{
    return _outPos;
}

QVariant BlockConnectorItem::itemChange(QGraphicsItem::GraphicsItemChange change, const QVariant &value)
{
    if (change == ItemSelectedHasChanged && scene())
    {
        if(isSelected())
            setZValue(-1);
        else
            setZValue(-2);
    }
    return QGraphicsItem::itemChange(change, value);
}


