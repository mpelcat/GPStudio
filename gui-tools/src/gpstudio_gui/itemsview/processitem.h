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

#ifndef PROCESSITEM_H
#define PROCESSITEM_H

#include "gpstudio_gui_common.h"

#include <QGraphicsItem>
#include <QSvgRenderer>

class ProcessLib;
class IOLib;

class ProcessConnectorItem;

class GPSTUDIO_GUI_EXPORT ProcessItem : public QGraphicsItem
{
public:
    ProcessItem(ProcessLib *processLib=NULL);
    ProcessItem(IOLib *ioLib=NULL);
    ~ProcessItem();

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

    void addConnect(ProcessConnectorItem *connectItem);

protected:
    QVariant itemChange(GraphicsItemChange change, const QVariant &value);

private:
    QString _processName;
    QString _name;

    QRectF _boundingRect;
    QSvgRenderer _svgRenderer;

    QList<ProcessConnectorItem *> _connects;
};

#endif // PROCESSITEM_H
