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

#ifndef LIBITEMMODEL_H
#define LIBITEMMODEL_H

#include "gpstudio_gui_common.h"

#include <QAbstractItemModel>
#include <QList>

#include "lib_parser/lib.h"

class GPSTUDIO_GUI_EXPORT LibItemModel : public QAbstractItemModel
{
    Q_OBJECT
public:
    explicit LibItemModel(QObject *parent = 0);

    enum Column {
        Name,
        Description,
        ColumnCount
    };

    int columnCount(const QModelIndex &parent) const;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const;
    QVariant data(const QModelIndex &index, int role) const;
    QModelIndex index(int row, int column, const QModelIndex &parent) const;
    QModelIndex parent(const QModelIndex &child) const;
    int rowCount(const QModelIndex &parent) const;
    Qt::ItemFlags flags(const QModelIndex &index) const;

    void setLib(const Lib *lib);
    QList<ProcessLib> processList() const;

signals:

public slots:

private:
    QList<ProcessLib> _processList;

};

#endif // LIBITEMMODEL_H
