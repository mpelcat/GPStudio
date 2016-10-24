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

#include "cameraitem.h"

#include "camera/camera.h"
#include "cameracom.h"

#include "cameraitemmodel.h"

#include "model/model_gpviewer.h"
#include "model/model_viewer.h"
#include "model/model_viewerflow.h"

#include <QIcon>

CameraItem::CameraItem()
{
    _type = NullType;
    _ptr = NULL;
}

CameraItem::CameraItem(const Camera *camera)
{
    _type = CameraType;
    _ptr = camera;
}

CameraItem::CameraItem(const ModelNode *node)
{
    _type = ModelNodeType;
    _ptr = node;
}

CameraItem::CameraItem(const Block *block)
{
    _type = BlockType;
    _ptr = block;
}

CameraItem::CameraItem(const ModelBlock *block)
{
    _type = ModelBlockType;
    _ptr = block;
}

CameraItem::CameraItem(const Flow *flow)
{
    _type = FlowType;
    _ptr = flow;
}

CameraItem::CameraItem(const ModelFlow *flow)
{
    _type = ModelFlowType;
    _ptr = flow;
}

CameraItem::CameraItem(const ModelGPViewer *gpViewer)
{
    _type = ModelGPViewerType;
    _ptr = gpViewer;
}

CameraItem::CameraItem(const ModelViewer *viewer)
{
    _type = ModelViewerType;
    _ptr = viewer;
}

CameraItem::CameraItem(const ModelViewerFlow *viewerFlow)
{
    _type = ModelViewerFlowType;
    _ptr = viewerFlow;
}

CameraItem::~CameraItem()
{
    foreach (CameraItem *item, _childrens) delete item;
}

CameraItem::Type CameraItem::type() const
{
    return _type;
}

const Camera *CameraItem::camera() const
{
    if(_type==CameraType)
        return static_cast<const Camera*>(_ptr);
    return NULL;
}

const Block *CameraItem::block() const
{
    if(_type==BlockType)
        return static_cast<const Block*>(_ptr);
    return NULL;
}

const Flow *CameraItem::flow() const
{
    if(_type==FlowType)
        return static_cast<const Flow*>(_ptr);
    return NULL;
}

const ModelNode *CameraItem::modelNode() const
{
    if(_type==ModelNodeType)
        return static_cast<const ModelNode*>(_ptr);
    return NULL;
}

const ModelBlock *CameraItem::modelBlock() const
{
    if(_type==ModelBlockType)
        return static_cast<const ModelBlock*>(_ptr);
    return NULL;
}

const ModelFlow *CameraItem::modelFlow() const
{
    if(_type==ModelFlowType)
        return static_cast<const ModelFlow*>(_ptr);
    return NULL;
}

const ModelGPViewer *CameraItem::modelGPViewer() const
{
    if(_type==ModelGPViewerType)
        return static_cast<const ModelGPViewer*>(_ptr);
    return NULL;
}

const ModelViewer *CameraItem::modelViewer() const
{
    if(_type==ModelViewerType)
        return static_cast<const ModelViewer*>(_ptr);
    return NULL;
}

const ModelViewerFlow *CameraItem::modelViewerFlow() const
{
    if(_type==ModelViewerFlowType)
        return static_cast<const ModelViewerFlow*>(_ptr);
    return NULL;
}

const QList<CameraItem*> &CameraItem::childrens() const
{
    return _childrens;
}

const CameraItem *CameraItem::children(int i) const
{
    return _childrens[i];
}

int CameraItem::count() const
{
    return _childrens.count();
}

CameraItem *CameraItem::append(const Camera *camera)
{
    CameraItem *item = new CameraItem(camera);
    item->_parent = this;
    item->_row = _childrens.count();

    foreach (Block *block, camera->blocks())
    {
        item->append(block);
    }

    _childrens.append(item);
    return item;
}

CameraItem *CameraItem::append(const ModelNode *node)
{
    CameraItem *item = new CameraItem(node);
    item->_parent = this;
    item->_row = _childrens.count();

    foreach (ModelBlock *block, node->blocks())
    {
        item->append(block);
    }

    _childrens.append(item);
    return item;
}

CameraItem *CameraItem::append(const Block *block)
{
    CameraItem *item = new CameraItem(block);
    item->_parent = this;
    item->_row = _childrens.count();

    if(!block->flows().empty())
    {
        foreach (Flow *flow, block->flows())
        {
            item->append(flow);
        }
    }

    _childrens.append(item);
    return item;
}

CameraItem *CameraItem::append(const ModelBlock *block)
{
    CameraItem *item = new CameraItem(block);
    item->_parent = this;
    item->_row = _childrens.count();

    if(!block->flows().empty())
    {
        foreach (ModelFlow *flow, block->flows())
        {
            item->append(flow);
        }
    }

    _childrens.append(item);
    return item;
}

CameraItem *CameraItem::append(const Flow *flow)
{
    CameraItem *item = new CameraItem(flow);
    item->_parent = this;
    item->_row = _childrens.count();
    _childrens.append(item);
    return item;
}

CameraItem *CameraItem::append(const ModelFlow *flow)
{
    CameraItem *item = new CameraItem(flow);
    item->_parent = this;
    item->_row = _childrens.count();
    _childrens.append(item);
    return item;
}

CameraItem *CameraItem::append(const ModelGPViewer *gpViewer)
{
    foreach (ModelViewer *viewer, gpViewer->viewers())
    {
        append(viewer);
    }
    return this;
}

CameraItem *CameraItem::append(const ModelViewer *viewer)
{
    CameraItem *item = new CameraItem(viewer);
    item->_parent = this;
    item->_row = _childrens.count();

    foreach (ModelViewerFlow *viewer, viewer->viewerFlows())
    {
        item->append(viewer);
    }

    _childrens.append(item);
    return item;
}

CameraItem *CameraItem::append(const ModelViewerFlow *viewerFlow)
{
    CameraItem *item = new CameraItem(viewerFlow);
    item->_parent = this;
    item->_row = _childrens.count();
    _childrens.append(item);
    return item;
}

void CameraItem::clear()
{
    _childrens.clear();
}

int CameraItem::row()
{
    return _row;
}

void *CameraItem::ptr() const
{
    return (void*)(this);
}

CameraItem *CameraItem::parent() const
{
    return _parent;
}

QVariant CameraItem::value(int column, int role) const
{
    switch (type())
    {
    case CameraItem::CameraType:
        switch (role)
        {
        case Qt::DisplayRole:
            switch (column)
            {
            case CameraItemModelNoSorted::Name:
                if(camera()->node())
                    return QVariant(camera()->node()->name());
                else
                    return QVariant();
            case CameraItemModelNoSorted::Value:
                if(camera()->isConnected())
                    return QVariant(camera()->com()->info().name());
                else
                    return QVariant("Not connected");
            default:
                return QVariant();
            }
        case Qt::DecorationRole:
            if(column==0)
            {
                return QIcon(":/icons/img/usb.png");
            }
        }
        return QVariant();
    case CameraItem::ModelNodeType:
        switch (role)
        {
        case Qt::DisplayRole:
            switch (column)
            {
            case CameraItemModelNoSorted::Name:
                return QVariant(modelNode()->name());
            case CameraItemModelNoSorted::Value:
                return QVariant("");
            default:
                return QVariant();
            }
        case Qt::DecorationRole:
            if(column==0)
            {
                return QIcon(":/icons/img/usb.png");
            }
        }
        return QVariant();
    case CameraItem::BlockType:
        switch (role)
        {
        case Qt::DisplayRole:
            switch (column)
            {
            case CameraItemModelNoSorted::Name:
                return QVariant(block()->name());
            default:
                return QVariant(block()->modelBlock()->driver());
            }
        }
        return QVariant();
    case CameraItem::ModelBlockType:
        switch (role)
        {
        case Qt::DisplayRole:
            switch (column)
            {
            case CameraItemModelNoSorted::Name:
                return QVariant(modelBlock()->name());
            default:
                return QVariant(modelBlock()->driver());
            }
        }
        return QVariant();
    case CameraItem::FlowType:
        switch (role)
        {
        case Qt::DisplayRole:
            switch (column)
            {
            case CameraItemModelNoSorted::Name:
                return QVariant(flow()->name());
            case CameraItemModelNoSorted::Value:
                return QVariant(flow()->type()==Flow::Input ? "in" : "out");
            default:
                return QVariant();
            }
        case Qt::DecorationRole:
            if(column==0)
            {
                if(flow()->type()==Flow::Input)
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
            switch (column)
            {
            case CameraItemModelNoSorted::Name:
                return QVariant(modelFlow()->name());
            case CameraItemModelNoSorted::Value:
                return QVariant(modelFlow()->type());
            default:
                return QVariant();
            }
        case Qt::DecorationRole:
            if(column==0)
            {
                if(modelFlow()->type()=="in")
                    return QIcon(":/icons/img/flow-in.png");
                else
                    return QIcon(":/icons/img/flow-out.png");
            }
        }
        return QVariant();
    case CameraItem::ModelGPViewerType:
        switch (role)
        {
        case Qt::DisplayRole:
            switch (column)
            {
            case CameraItemModelNoSorted::Name:
                return QVariant(modelGPViewer()->name());
            default:
                return QVariant();
            }
        }
        return QVariant();
    case CameraItem::ModelViewerType:
        switch (role)
        {
        case Qt::DisplayRole:
            switch (column)
            {
            case CameraItemModelNoSorted::Name:
                return QVariant(modelViewer()->name());
            default:
                return QVariant();
            }
        }
        return QVariant();
    case CameraItem::ModelViewerFlowType:
        switch (role)
        {
        case Qt::DisplayRole:
            switch (column)
            {
            case CameraItemModelNoSorted::Name:
                return QVariant(modelGPViewer()->name());
            default:
                return QVariant();
            }
        }
        return QVariant();
    default:
        return QVariant();
    }
}
