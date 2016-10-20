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
    addCamera(camera);
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
    if(_rootItem->count()==0)
        return QVariant();

    CameraItem *item = static_cast<CameraItem*>(index.internalPointer());
    // ============== cam mode ==============
    switch (item->type())
    {
    case CameraItem::CameraType:
        switch (role)
        {
        case Qt::DisplayRole:
            switch (index.column())
            {
            case Name:
                if(item->camera()->node())
                    return QVariant(item->camera()->node()->name());
                else
                    return QVariant();
            case Value:
                if(item->camera()->isConnected())
                    return QVariant(item->camera()->com()->info().name());
                else
                    return QVariant("Not connected");
            default:
                return QVariant();
            }
        case Qt::DecorationRole:
            if(index.column()==0)
            {
                return QIcon(":/icons/img/usb.png");
            }
        }
        return QVariant();
    case CameraItem::ModelNodeType:
        switch (role)
        {
        case Qt::DisplayRole:
            switch (index.column())
            {
            case Name:
                return QVariant(item->modelNode()->name());
            case Value:
                return QVariant("");
            default:
                return QVariant();
            }
        case Qt::DecorationRole:
            if(index.column()==0)
            {
                return QIcon(":/icons/img/usb.png");
            }
        }
        return QVariant();
    case CameraItem::BlockType:
        switch (role)
        {
        case Qt::DisplayRole:
            switch (index.column())
            {
            case Name:
                return QVariant(item->block()->name());
            default:
                return QVariant(item->block()->modelBlock()->driver());
            }
        }
        return QVariant();
    case CameraItem::ModelBlockType:
        switch (role)
        {
        case Qt::DisplayRole:
            switch (index.column())
            {
            case Name:
                return QVariant(item->modelBlock()->name());
            default:
                return QVariant(item->modelBlock()->driver());
            }
        }
        return QVariant();
    case CameraItem::FlowType:
        switch (role)
        {
        case Qt::DisplayRole:
            switch (index.column())
            {
            case Name:
                return QVariant(item->flow()->name());
            case Value:
                return QVariant(item->flow()->type()==Flow::Input ? "in" : "out");
            default:
                return QVariant();
            }
        case Qt::DecorationRole:
            if(index.column()==0)
            {
                if(item->flow()->type()==Flow::Input)
                    return QIcon(":/icons/img/flow-in.png");
                else
                    return QIcon(":/icons/img/flow-out.png");
            }
        }
        return QVariant();
    case CameraItem::ModelFlowType:
        switch (role)
        {
        case Qt::DisplayRole:
            switch (index.column())
            {
            case Name:
                return QVariant(item->modelFlow()->name());
            case Value:
                return QVariant(item->modelFlow()->type());
            default:
                return QVariant();
            }
        case Qt::DecorationRole:
            if(index.column()==0)
            {
                if(item->modelFlow()->type()=="in")
                    return QIcon(":/icons/img/flow-in.png");
                else
                    return QIcon(":/icons/img/flow-out.png");
            }
        }
        return QVariant();
    default:
        return QVariant();
    }

    return QVariant();
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

void CameraItemModelNoSorted::addCamera(const Camera *camera)
{
    beginResetModel();
    resetInternalData();
    _rootItem->append(camera);
    endResetModel();
}

void CameraItemModelNoSorted::addBlock(const Block *block)
{
    beginResetModel();
    resetInternalData();
    _rootItem->append(block);
    endResetModel();
}

void CameraItemModelNoSorted::addNode(const ModelNode *node)
{
    beginResetModel();
    resetInternalData();
    _rootItem->append(node);
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

void CameraItemModel::addCamera(const Camera *camera)
{
    _modelCam->addCamera(camera);
}

void CameraItemModel::clearAll()
{
    _modelCam->clearAll();
}
