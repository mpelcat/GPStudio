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

#include "libitemmodel.h"

LibItemModel::LibItemModel(QObject *parent) :
    QAbstractItemModel(parent)
{
}

int LibItemModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return ColumnCount;
}

QVariant LibItemModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if(orientation==Qt::Vertical) return QVariant();
    switch (role)
    {
    case Qt::DisplayRole:
        switch (section)
        {
        case Name:
            return QVariant("Name");
        case Description:
            return QVariant("Description");
        default:
            return QVariant();
        }
    break;
    }
    return QVariant();
}

QVariant LibItemModel::data(const QModelIndex &index, int role) const
{
    if(index.row()>=_processList.count()) return QVariant();

    const ProcessLib &processLib = _processList[index.row()];

    switch (role)
    {
    case Qt::DisplayRole:
        switch (index.column())
        {
        case Name:
            return QVariant(processLib.name());
        case Description:
            return QVariant(processLib.description());
        default:
            return QVariant();
        }
    case Qt::DecorationRole:
        if(index.column()==Name)
            return QVariant(processLib.icon());
        break;
    case Qt::ToolTipRole:
        return QVariant(processLib.description());
    case Qt::UserRole:
        return index.row();
    }
    return QVariant();
}

QModelIndex LibItemModel::index(int row, int column, const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return createIndex(row, column);
}

QModelIndex LibItemModel::parent(const QModelIndex &child) const
{
    Q_UNUSED(child);
    return QModelIndex();
}

int LibItemModel::rowCount(const QModelIndex &parent) const
{
    if(!parent.isValid()) return _processList.count();
    return 0;
}

Qt::ItemFlags LibItemModel::flags(const QModelIndex &index) const
{
    Qt::ItemFlags defaultFlags = QAbstractItemModel::flags(index);

    if (index.isValid())
        return Qt::ItemIsDragEnabled | defaultFlags;
    else
        return defaultFlags;
}

void LibItemModel::setLib(const Lib *lib)
{
    emit layoutAboutToBeChanged();

    _processList.clear();
    foreach(ProcessLib *processLib, lib->processes())
    {
        _processList.append(*processLib);
    }

    emit layoutChanged();
}

QList<ProcessLib> LibItemModel::processList() const
{
    return _processList;
}
