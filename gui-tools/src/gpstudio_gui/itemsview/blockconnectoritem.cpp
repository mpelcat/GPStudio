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
    if(_portItem1)
        _portItem1->addConnect(this);
    if(_portItem2)
        _portItem2->addConnect(this);
    setZValue(-1);
    _style=CubicDraw;
    updateShape();
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
    return QRectF(_inPos, _outPos).normalized().adjusted(-10, -10, 10, 10);
}

void BlockConnectorItem::paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
{
    Q_UNUSED(option)
    Q_UNUSED(widget)

    // start draw
    painter->setPen(QPen(Qt::black, 3));

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
        path.lineTo(QPoint(rect.center().x(), y1));
        path.lineTo(QPoint(rect.center().x(), y2));
        path.lineTo(_inPos);
    }
    else
    {
        path.cubicTo(QPoint(rect.center().x(), y1), QPoint(rect.center().x(), y2), _inPos);
    }

    painter->drawPath(path);
}

void BlockConnectorItem::updateShape()
{
    bool inInit=false, outInit=false;

    prepareGeometryChange();

    // compute point start and end
    if(_portItem1)
    {
        if(_portItem1->direction()==BlockPortItem::Input)
        {
            _inPos = _portItem1->connectorPos();
            inInit = true;
        }
        else
        {
            _outPos = _portItem1->connectorPos();
            outInit = true;
        }
    }
    if(_portItem2)
    {
        if(_portItem2->direction()==BlockPortItem::Input)
        {
            _inPos = _portItem2->connectorPos();
            inInit = true;
        }
        else
        {
            _outPos = _portItem2->connectorPos();
            outInit = true;
        }
    }
    if(!inInit)
        _inPos = _endPos;
    if(!outInit)
        _outPos = _endPos;
}

QPoint BlockConnectorItem::endPos() const
{
    return _endPos;
}

void BlockConnectorItem::setEndPos(const QPoint &endPos)
{
    _endPos = endPos;
    updateShape();
}


