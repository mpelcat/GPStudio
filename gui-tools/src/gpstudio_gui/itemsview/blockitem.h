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

#ifndef BLOCKITEM_H
#define BLOCKITEM_H

#include "gpstudio_gui_common.h"

#include <QGraphicsItem>
#include <QSvgRenderer>
#include <QMap>

class ProcessLib;
class IOLib;
class ModelBlock;
class Block;

class BlockPortItem;

class GPSTUDIO_GUI_EXPORT BlockItem : public QGraphicsItem
{
public:
    BlockItem();
    ~BlockItem();

    enum { Type = UserType + 1 };
    int type() const;

    QRectF boundingRect() const;
    void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget);

    QString processName() const;
    void setProcessName(const QString &processName);

    QString name() const;
    void setName(const QString &name);

    const Block *block() const;

    void updateBlock();

    void addPort(BlockPortItem *portItem);
    BlockPortItem *port(const QString &name) const;
    const QMap<QString, BlockPortItem *> &ports() const;

public:
    // lib
    static BlockItem *fromIoLib(const IOLib *ioLib, BlockItem *item = NULL);
    static BlockItem *fromProcessLib(const ProcessLib *processLib, BlockItem *item = NULL);

    // model
    static BlockItem *fromModelBlock(const ModelBlock *modelBlock, BlockItem *item = NULL);

    // camera model
    static BlockItem *fromBlock(const Block *block, BlockItem *item = NULL);

protected:
    QVariant itemChange(GraphicsItemChange change, const QVariant &value);

private:
    QString _processName;
    QString _name;

    QRectF _boundingRect;
    QSvgRenderer _svgRenderer;

    QMap<QString, BlockPortItem *> _ports;

    const Block *_block;
};

#endif // BLOCKITEM_H
