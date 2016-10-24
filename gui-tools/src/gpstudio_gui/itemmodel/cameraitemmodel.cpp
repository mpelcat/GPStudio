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

#include "cameraitemmodel.h"

#include "camera/camera.h"
#include "cameracom.h"

#include "model/model_node.h"

#include <QDebug>
#include <QIcon>

CameraItemModelNoSorted::CameraItemModelNoSorted(QObject *parent)
    : QAbstractItemModel(parent)
{
    _rootItem = new CameraItem();
}

CameraItemModelNoSorted::CameraItemModelNoSorted(Camera *camera, QObject *parent)
    : QAbstractItemModel(parent)
{
    _rootItem = new CameraItem();
    setCamera(camera);
}

QModelIndex CameraItemModelNoSorted::index(int row, int column, const QModelIndex &parent) const
{
    if (!hasIndex(row, column, parent))
            return QModelIndex();

    CameraItem *parentItem;

    if (!parent.isValid())
        parentItem = _rootItem;
    else
        parentItem = static_cast<CameraItem*>(parent.internalPointer());

    const CameraItem *childItem = parentItem->children(row);
    if (childItem)
        return createIndex(row, column, childItem->ptr());
    else
        return QModelIndex();
}

QModelIndex CameraItemModelNoSorted::parent(const QModelIndex &child) const
{
    if (!child.isValid() || child.internalPointer()==NULL)
        return QModelIndex();

    CameraItem *childItem = static_cast<CameraItem*>(child.internalPointer());
    CameraItem *parentItem = childItem->parent();

    if (parentItem == _rootItem)
        return QModelIndex();

    return createIndex(parentItem->row(), 0, parentItem);
}

int CameraItemModelNoSorted::rowCount(const QModelIndex &parent) const
{
    if (parent.column() > 0)
            return 0;

    if(!parent.isValid()) // root item
    {
        return _rootItem->count();
    }
    else
    {
        CameraItem *item = static_cast<CameraItem*>(parent.internalPointer());
        if(item)
            return item->count();
    }
    return 0;
}

int CameraItemModelNoSorted::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return ColumnCount;
}

QVariant CameraItemModelNoSorted::data(const QModelIndex &index, int role) const
{
    if(!index.isValid())
        return QVariant();

    if(_rootItem->count()==0)
        return QVariant();

    CameraItem *item = static_cast<CameraItem*>(index.internalPointer());

    return item->value(index.column(), role);
}

QVariant CameraItemModelNoSorted::headerData(int section, Qt::Orientation orientation, int role) const
{
    if(orientation==Qt::Vertical) return QVariant();
    switch (role)
    {
    case Qt::DisplayRole:
        switch (section)
        {
        case Name:
            return QVariant("Name");
        case Value:
            return QVariant("Value");
        default:
            return QVariant();
        }
        break;
    }
    return QVariant();
}

void CameraItemModelNoSorted::setCamera(const Camera *camera)
{
    beginResetModel();
    resetInternalData();
    _rootItem->append(camera);
    endResetModel();
}

void CameraItemModelNoSorted::setBlock(const Block *block)
{
    beginResetModel();
    resetInternalData();
    _rootItem->clear();
    _rootItem->append(block);
    endResetModel();
}

void CameraItemModelNoSorted::setNode(const ModelNode *node)
{
    beginResetModel();
    resetInternalData();
    _rootItem->clear();
    _rootItem->append(node);
    endResetModel();
}

void CameraItemModelNoSorted::setViewer(const ModelGPViewer *gpViewer)
{
    beginResetModel();
    resetInternalData();
    _rootItem->clear();
    _rootItem->append(gpViewer);
    endResetModel();
}

void CameraItemModelNoSorted::clearAll()
{
    beginResetModel();
    resetInternalData();
    _rootItem->clear();
    endResetModel();
}


// =============== sorted model ====================
CameraItemModel::CameraItemModel(QObject *parent)
    : QSortFilterProxyModel(parent)
{
    _modelCam = new CameraItemModelNoSorted(this);
    setSourceModel(_modelCam);
}

CameraItemModel::CameraItemModel(Camera *camera, QObject *parent)
{
    _modelCam = new CameraItemModelNoSorted(camera, parent);
    setSourceModel(_modelCam);
    //setFilterWildcard("pro*");
}

void CameraItemModel::setCamera(const Camera *camera)
{
    _modelCam->setCamera(camera);
}

void CameraItemModel::setBlock(const Block *block)
{
    _modelCam->setBlock(block);
}

void CameraItemModel::setNode(const ModelNode *node)
{
    _modelCam->setNode(node);
}

void CameraItemModel::setViewer(const ModelGPViewer *gpViewer)
{
    _modelCam->setViewer(gpViewer);
}

void CameraItemModel::clearAll()
{
    _modelCam->clearAll();
}
