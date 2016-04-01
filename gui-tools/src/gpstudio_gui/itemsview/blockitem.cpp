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
#include "blockportitem.h"

#include <QPainter>
#include <QDebug>

#include "lib_parser/processlib.h"
#include "lib_parser/iolib.h"

BlockItem::BlockItem(ProcessLib *processLib)
{
    setFlag(ItemIsMovable, true);
    setFlag(ItemIsSelectable, true);

    update(processLib);
}

BlockItem::BlockItem(IOLib *ioLib)
{
    setFlag(ItemIsMovable, true);
    setFlag(ItemIsSelectable, true);

    update(ioLib);
}

BlockItem::~BlockItem()
{
}

int BlockItem::type() const
{
    return Type;
}

QRectF BlockItem::boundingRect() const
{
    return _boundingRect;
}

void BlockItem::paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
{
    Q_UNUSED(option); Q_UNUSED(widget);

    if(_svgRenderer.isValid())
    {
        _svgRenderer.render(painter, _svgRenderer.viewBox());
        painter->drawRect(_svgRenderer.viewBox());
    }
    else
    {
        painter->drawRect(QRect(0,0,125,50));
    }
}

QString BlockItem::processName() const
{
    return _processName;
}

void BlockItem::setProcessName(const QString &processName)
{
    _processName = processName;
}

QString BlockItem::name() const
{
    return _name;
}

void BlockItem::setName(const QString &name)
{
    _name = name;
}

void BlockItem::update(ProcessLib *processLib)
{
    if(!processLib) return;
    _svgRenderer.load(processLib->draw().toUtf8());

    if(_svgRenderer.isValid())
    {
        _boundingRect = _svgRenderer.viewBoxF().adjusted(-10,-10,10,10);
    }
    else
    {
        _boundingRect = QRectF(0,0,125,50).adjusted(-10,-10,10,10);
    }
}

void BlockItem::update(IOLib *ioLib)
{
    if(!ioLib) return;
    _svgRenderer.load(ioLib->draw().toUtf8());

    if(_svgRenderer.isValid())
    {
        _boundingRect = _svgRenderer.viewBoxF().adjusted(-10,-10,10,10);
    }
    else
    {
        _boundingRect = QRectF(0,0,125,50).adjusted(-10,-10,10,10);
    }
}

void BlockItem::addPort(BlockPortItem *connectItem)
{
    connectItem->setParentItem(this);
    connectItem->setPos(0,30);
    _connects.append(connectItem);
}

QVariant BlockItem::itemChange(QGraphicsItem::GraphicsItemChange change, const QVariant &value)
{
    /*if (change == ItemPositionChange && scene())
    {
        foreach (BlockConnectorItem *connectItem, _connects)
        {
            connectItem->update();
        }
    }*/
    return QGraphicsItem::itemChange(change, value);
}
