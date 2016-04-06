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
    : _portItemOut(portItemOut), _portItemIn(portItemIn)
{
    if(_portItemOut)
        _portItemOut->addConnect(this);
    if(_portItemIn)
        _portItemIn->addConnect(this);
    setZValue(-1);
    _style=CubicDraw;
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
    if(_portItemOut!=NULL && _portItemIn!=NULL)
    {
        return QRectF(_portItemOut->scenePos(), _portItemIn->scenePos()).normalized();
    }
    return QRectF();
}

void BlockConnectorItem::paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
{
    Q_UNUSED(option)
    Q_UNUSED(widget)
    if(_portItemOut && _portItemIn)
    {
        painter->setPen(QPen(Qt::black, 3));

        QRectF rect = QRectF(_portItemOut->scenePos(), _portItemIn->scenePos()).normalized();

        int y1, y2;
        if(_portItemOut->scenePos().y() > _portItemIn->scenePos().y())
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
        path.moveTo(_portItemOut->scenePos());
        if(_style==LineDraw)
        {
            path.lineTo(QPoint(rect.center().x(), y1));
            path.lineTo(QPoint(rect.center().x(), y2));
            path.lineTo(_portItemIn->scenePos());
        }
        else
        {
            path.cubicTo(QPoint(rect.center().x(), y1), QPoint(rect.center().x(), y2), _portItemIn->scenePos());
        }

        painter->drawPath(path);
    }
}

void BlockConnectorItem::updateShape()
{
    prepareGeometryChange();
}


