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

#include "blockportitem.h"
#include "blockconnectoritem.h"

#include <QPainter>
#include <QDebug>
#include <QCursor>

#include "lib_parser/processlib.h"
#include "lib_parser/iolib.h"

#include "model/model_flow.h"

BlockPortItem::BlockPortItem()
{
    setFlag(ItemIsSelectable, true);
    setAcceptHoverEvents(true);
    _direction = Input;
    setCursor(Qt::CrossCursor);
    _hover = false;
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
    if(_direction==Input)
        return QRectF(-15,-15,90,30);
    else
        return QRectF(-40,-15,90,30);
}

QPainterPath BlockPortItem::shape() const
{
    QPainterPath path;

    path.moveTo(-12, -12);
    path.lineTo(12, 0);
    path.lineTo(-12, 12);
    path.closeSubpath();

    return path;
}

void BlockPortItem::paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
{
    Q_UNUSED(option); Q_UNUSED(widget);

    QPainterPath path;

    if(_hover)
    {
        path.moveTo(-11, -11);
        path.lineTo(11, 0);
        path.lineTo(-11, 11);
        path.closeSubpath();
    }
    else
    {
        path.moveTo(-9, -9);
        path.lineTo(9, 0);
        path.lineTo(-9, 9);
        path.closeSubpath();
    }

    painter->setPen(QPen(Qt::transparent));

    if(_direction==Input)
    {
        QLinearGradient grad(-15,-15,15,15);
        grad.setColorAt(0, QColor("blue"));
        grad.setColorAt(1, QColor("blue").darker());
        painter->setBrush(grad);
        painter->drawPath(path);

        painter->setPen(QPen());
        painter->drawText(QRectF(10,-10,70,20), Qt::AlignLeft | Qt::AlignVCenter, _name);
    }
    else
    {
        QLinearGradient grad(-15,-15,15,15);
        grad.setColorAt(0, QColor("orange"));
        grad.setColorAt(1, QColor("orange").darker());
        painter->setBrush(grad);
        painter->drawPath(path);

        painter->setPen(QPen());
        painter->drawText(QRectF(-80,-10,70,20), Qt::AlignRight | Qt::AlignVCenter, _name);
    }
}

QString BlockPortItem::name() const
{
    return _name;
}

void BlockPortItem::setName(const QString &name)
{
    _name = name;
    update();
}

BlockPortItem::Direction BlockPortItem::direction() const
{
    return _direction;
}

void BlockPortItem::setDirection(const BlockPortItem::Direction &direction)
{
    _direction = direction;
    update();
}

void BlockPortItem::addConnect(BlockConnectorItem *connectItem)
{
    _connects.append(connectItem);
}

const QList<BlockConnectorItem *> &BlockPortItem::connects() const
{
    return _connects;
}

QPointF BlockPortItem::connectorPos() const
{
    if(_direction==Input)
        return scenePos()+QPointF(-7,0);
    else
        return scenePos()+QPointF(7,0);
}

BlockPortItem *BlockPortItem::fromModelFlow(ModelFlow *modelFlow)
{
    BlockPortItem *item = new BlockPortItem();

    item->_name = modelFlow->name();
    if(modelFlow->type()=="in")
        item->_direction = Input;
    else
        item->_direction = Output;

    item->_modelFlow = modelFlow;

    return item;
}

void BlockPortItem::hoverEnterEvent(QGraphicsSceneHoverEvent *event)
{
    _hover = true;
    prepareGeometryChange();
    QGraphicsItem::hoverEnterEvent(event);
}

void BlockPortItem::hoverLeaveEvent(QGraphicsSceneHoverEvent *event)
{
    _hover = false;
    prepareGeometryChange();
    QGraphicsItem::hoverLeaveEvent(event);
}

ModelFlow *BlockPortItem::modelFlow() const
{
    return _modelFlow;
}

void BlockPortItem::setModelFlow(ModelFlow *modelFlow)
{
    _modelFlow = modelFlow;
}
