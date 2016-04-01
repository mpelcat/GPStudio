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

#ifndef BLOCKPORTITEM_H
#define BLOCKPORTITEM_H

#include "gpstudio_gui_common.h"

#include <QGraphicsItem>

class BlockConnectorItem;

class GPSTUDIO_GUI_EXPORT BlockPortItem : public QGraphicsItem
{
public:
    BlockPortItem();
    ~BlockPortItem();

    enum { Type = UserType + 3 };
    int type() const;

    QRectF boundingRect() const;
    void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget);

    QString processName() const;
    void setProcessName(const QString &processName);

    QString name() const;
    void setName(const QString &name);

    void addConnect(BlockConnectorItem *connectItem);

protected:
    QVariant itemChange(GraphicsItemChange change, const QVariant &value);

private:
    QString _processName;
    QString _name;

    QList<BlockConnectorItem *> _connects;
};

#endif // BLOCKPORTITEM_H
