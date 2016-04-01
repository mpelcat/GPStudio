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

class ProcessLib;
class IOLib;

class BlockPortItem;

class GPSTUDIO_GUI_EXPORT BlockItem : public QGraphicsItem
{
public:
    BlockItem(ProcessLib *processLib=NULL);
    BlockItem(IOLib *ioLib=NULL);
    ~BlockItem();

    enum { Type = UserType + 1 };
    int type() const;

    QRectF boundingRect() const;
    void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget);

    QString processName() const;
    void setProcessName(const QString &processName);

    QString name() const;
    void setName(const QString &name);

    void update(ProcessLib *processLib);
    void update(IOLib *ioLib);

    void addPort(BlockPortItem *portItem);

protected:
    QVariant itemChange(GraphicsItemChange change, const QVariant &value);

private:
    QString _processName;
    QString _name;

    QRectF _boundingRect;
    QSvgRenderer _svgRenderer;

    QList<BlockPortItem *> _ports;
};

#endif // BLOCKITEM_H
