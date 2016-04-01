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

#include <QPainter>

#include "lib_parser/processlib.h"
#include "lib_parser/iolib.h"

BlockPortItem::BlockPortItem()
{
    setFlag(ItemIsSelectable, true);
}

BlockPortItem::~BlockPortItem()
{
}

int BlockPortItem::type() const
{
    return Type;
}

QRectF BlockPortItem::boundingRect() const
{
    return QRectF(-10,-10,20,20);
}

void BlockPortItem::paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
{
    Q_UNUSED(option); Q_UNUSED(widget);

    QPainterPath path;

    path.moveTo(-9, -9);
    path.lineTo(9, 0);
    path.lineTo(-9, 9);
    path.closeSubpath();

    painter->setPen(QPen(Qt::transparent));

    QLinearGradient grad(-15,-15,15,15);
    grad.setColorAt(0, QColor("orange"));
    grad.setColorAt(1, QColor("orange").darker());
    painter->setBrush(grad);

    painter->drawPath(path);
}

QString BlockPortItem::processName() const
{
    return _processName;
}

void BlockPortItem::setProcessName(const QString &processName)
{
    _processName = processName;
}

QString BlockPortItem::name() const
{
    return _name;
}

void BlockPortItem::setName(const QString &name)
{
    _name = name;
}

void BlockPortItem::addConnect(BlockConnectorItem *connectItem)
{
    _connects.append(connectItem);
}

QVariant BlockPortItem::itemChange(QGraphicsItem::GraphicsItemChange change, const QVariant &value)
{
    if (change == ItemPositionChange && scene())
    {
        foreach (BlockConnectorItem *connectItem, _connects)
        {
            connectItem->update();
        }
    }
    return QGraphicsItem::itemChange(change, value);
}
