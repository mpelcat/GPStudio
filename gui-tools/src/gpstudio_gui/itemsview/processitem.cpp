/****************************************************************************
** Copyright (C) 2014 Dream IP
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

#include "processconnectoritem.h"
#include "processitem.h"

#include <QPainter>

#include "lib_parser/processlib.h"
#include "lib_parser/iolib.h"

ProcessItem::ProcessItem(ProcessLib *processLib)
{
    setFlag(ItemIsMovable, true);
    setFlag(ItemIsSelectable, true);

    update(processLib);
}

ProcessItem::ProcessItem(IOLib *ioLib)
{
    setFlag(ItemIsMovable, true);
    setFlag(ItemIsSelectable, true);

    update(ioLib);
}

ProcessItem::~ProcessItem()
{
}

int ProcessItem::type() const
{
    return Type;
}

QRectF ProcessItem::boundingRect() const
{
    return _boundingRect;
}

void ProcessItem::paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
{
    Q_UNUSED(option); Q_UNUSED(widget);

    if(_svgRenderer.isValid())
    {
        _svgRenderer.render(painter, boundingRect());
    }
    else
    {
        painter->drawRect(QRect(0,0,125,50));
    }
}

QString ProcessItem::processName() const
{
    return _processName;
}

void ProcessItem::setProcessName(const QString &processName)
{
    _processName = processName;
}

QString ProcessItem::name() const
{
    return _name;
}

void ProcessItem::setName(const QString &name)
{
    _name = name;
}

void ProcessItem::update(ProcessLib *processLib)
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

void ProcessItem::update(IOLib *ioLib)
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

void ProcessItem::addConnect(ProcessConnectorItem *connectItem)
{
    _connects.append(connectItem);
}

QVariant ProcessItem::itemChange(QGraphicsItem::GraphicsItemChange change, const QVariant &value)
{
    if (change == ItemPositionChange && scene())
    {
        foreach (ProcessConnectorItem *connectItem, _connects)
        {
            connectItem->update();
        }
    }
    return QGraphicsItem::itemChange(change, value);
}
