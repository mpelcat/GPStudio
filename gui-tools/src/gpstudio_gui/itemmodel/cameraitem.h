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

#ifndef CAMERAITEM_H
#define CAMERAITEM_H

#include "gpstudio_gui_common.h"

#include <QList>

class Camera;
class Block;
class Flow;
class ModelNode;
class ModelBlock;
class ModelFlow;

class GPSTUDIO_GUI_EXPORT CameraItem
{
public:
    CameraItem();
    CameraItem(const Camera *camera);
    CameraItem(const ModelNode *node);
    CameraItem(const Block *block);
    CameraItem(const ModelBlock *block);
    CameraItem(const Flow *flow);
    CameraItem(const ModelFlow *flow);
    ~CameraItem();

    enum Type {
        CameraType,
        BlockType,
        FlowType,

        ModelNodeType,
        ModelBlockType,
        ModelFlowType,

        NullType
    };

    Type type() const;

    const Camera *camera() const;
    const Block *block() const;
    const Flow *flow() const;
    const ModelNode *modelNode() const;
    const ModelBlock *modelBlock() const;
    const ModelFlow *modelFlow() const;

    const QList<CameraItem*> &childrens() const;
    const CameraItem *children(int i) const;
    int count() const;

    CameraItem *append(const Camera *camera);
    CameraItem *append(const ModelNode *node);
    CameraItem *append(const Block *block);
    CameraItem *append(const ModelBlock *block);
    CameraItem *append(const Flow *flow);
    CameraItem *append(const ModelFlow *flow);

    void clear();

    int row();
    void *ptr() const;
    CameraItem *parent() const;

protected:
    Type _type;
    const void *_ptr;

    int _row;
    CameraItem *_parent;

    QList<CameraItem*> _childrens;
};

#endif // CAMERAITEM_H
