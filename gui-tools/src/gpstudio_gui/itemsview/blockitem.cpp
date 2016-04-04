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

#include "blockconnectoritem.h"

#include "lib_parser/lib.h"

#include <QGraphicsScene>
#include <QGraphicsProxyWidget>
#include <QCheckBox>
#include <QSlider>

BlockItem::BlockItem()
{
    setFlag(ItemIsMovable, true);
    setFlag(ItemIsSelectable, true);
    setFlag(ItemSendsScenePositionChanges, true);

    QGraphicsProxyWidget *widget = new QGraphicsProxyWidget(this);
    QCheckBox *checkBox = new QCheckBox("en");
    checkBox->setGeometry(5,5,50,20);
    checkBox->setAutoFillBackground(false);
    checkBox->setAttribute(Qt::WA_NoSystemBackground);
    widget->setWidget(checkBox);

    QGraphicsProxyWidget *widget2 = new QGraphicsProxyWidget(this);
    QSlider *slider = new QSlider(Qt::Horizontal);
    slider->setGeometry(10,40,100,30);
    slider->setAutoFillBackground(false);
    slider->setAttribute(Qt::WA_NoSystemBackground);
    widget2->setWidget(slider);

    update();
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

void BlockItem::update()
{
    if(_svgRenderer.isValid())
    {
        _boundingRect = _svgRenderer.viewBoxF().adjusted(-10,-10,10,10);
    }
    else
    {
        _boundingRect = QRectF(0,0,125,50).adjusted(-10,-10,10,10);
    }
}

void BlockItem::addPort(BlockPortItem *portItem)
{
    portItem->setParentItem(this);
    _ports.append(portItem);
}

QVariant BlockItem::itemChange(QGraphicsItem::GraphicsItemChange change, const QVariant &value)
{
    if (change == ItemPositionChange && scene())
    {
        foreach (BlockPortItem *portItem, _ports)
        {
            foreach (BlockConnectorItem *connectItem, portItem->connects())
            {
                connectItem->updateShape();
            }
        }
    }
    return QGraphicsItem::itemChange(change, value);
}

BlockItem *BlockItem::fromIoLib(const IOLib *ioLib, BlockItem *item)
{
    if(!ioLib)
        return NULL;

    if(!item)
        item = new BlockItem();

    item->_svgRenderer.load(ioLib->draw().toUtf8());
    item->update();

    return item;
}

BlockItem *BlockItem::fromProcessLib(const ProcessLib *processLib, BlockItem *item)
{
    if(!processLib)
        return NULL;

    if(!item)
        item = new BlockItem();

    item->_svgRenderer.load(processLib->draw().toUtf8());
    item->update();

    return item;
}

BlockItem *BlockItem::fromModelBlock(const ModelBlock *modelBlock, BlockItem *item)
{

}

BlockItem *BlockItem::fromBlock(const Block *block, BlockItem *item)
{

}
