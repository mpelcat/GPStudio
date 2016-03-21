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

#include "cameraitem.h"

#include "camera/camera.h"

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

CameraItem::CameraItem(const Block *block)
{
    _type = BlockType;
    _ptr = block;
}

CameraItem::CameraItem(const Flow *flow)
{
    _type = FlowType;
    _ptr = flow;
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
    if(_type==CameraType) return static_cast<const Camera*>(_ptr);
    return NULL;
}

const Block *CameraItem::block() const
{
    if(_type==BlockType) return static_cast<const Block*>(_ptr);
    return NULL;
}

const Flow *CameraItem::flow() const
{
    if(_type==FlowType) return static_cast<const Flow*>(_ptr);
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

CameraItem *CameraItem::append(const Flow *flow)
{
    CameraItem *item = new CameraItem(flow);
    item->_parent = this;
    item->_row = _childrens.count();
    _childrens.append(item);
    return item;
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
