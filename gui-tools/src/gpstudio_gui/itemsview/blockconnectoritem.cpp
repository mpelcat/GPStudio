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

#include "blockitem.h"

#include <QDebug>
#include <QPainter>

BlockConnectorItem::BlockConnectorItem(BlockItem *itemOut, BlockItem *itemIn)
    : _itemOut(itemOut), _itemIn(itemIn)
{

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
    if(_itemOut!=NULL && _itemIn!=NULL)
    {
        return QRectF(_itemOut->pos(), _itemIn->pos()).normalized();
    }
    return QRectF();
}

void BlockConnectorItem::paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
{
    if(_itemOut && _itemIn)
    {
        painter->setPen(QPen(Qt::black, 3));
        painter->drawLine(_itemOut->pos(), _itemIn->pos());
    }
}

