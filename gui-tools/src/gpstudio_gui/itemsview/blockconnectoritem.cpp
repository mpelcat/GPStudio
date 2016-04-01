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
}

BlockConnectorItem::~BlockConnectorItem()
{
}

int BlockConnectorItem::type() const
{
    return Type;
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
    if(_portItemOut && _portItemIn)
    {
        painter->setPen(QPen(Qt::black, 3));

        QRectF rect = QRectF(_portItemOut->scenePos(), _portItemIn->scenePos()).normalized();
        QPainterPath path;
        path.moveTo(_portItemOut->scenePos());
        path.lineTo(rect.center().x(), rect.top());
        path.lineTo(rect.center().x(), rect.bottom());
        path.lineTo(rect.bottomRight());

        painter->drawPath(path);
    }
}

void BlockConnectorItem::updateShape()
{
    prepareGeometryChange();
}


