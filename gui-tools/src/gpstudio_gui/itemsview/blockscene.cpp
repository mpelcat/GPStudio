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

#include "blockscene.h"

#include "model/model_fiblock.h"

#include <QDebug>
#include <QMap>

#include "blockconnectoritem.h"

BlockScene::BlockScene()
{
}

BlockScene::~BlockScene()
{
}

bool BlockScene::loadFromNode(const ModelNode *node)
{
    clear();

    foreach (ModelBlock *block, node->blocks())
    {
        if(block->name()!="pi" && block->name()!="fi" && block->name()!="ci")
        {
            BlockItem *blockItem = BlockItem::fromModelBlock(block);
            _blocks.insert(block->name(), blockItem);
            addItem(blockItem);
        }
    }

    foreach (ModelFlowConnect *flowConnect, node->getFIBlock()->flowConnects())
    {
        QMap<QString, BlockItem* >::const_iterator fromblockIt = _blocks.find(flowConnect->fromblock());
        if(fromblockIt==_blocks.end()) continue;
        BlockItem *fromblockItem = fromblockIt.value();

        QMap<QString, BlockPortItem* >::const_iterator fromflowIt = fromblockItem->ports().find(flowConnect->fromflow());
        if(fromflowIt==fromblockItem->ports().end()) continue;
        BlockPortItem *fromflowItem = fromflowIt.value();

        QMap<QString, BlockItem* >::const_iterator toblockIt = _blocks.find(flowConnect->toblock());
        if(toblockIt==_blocks.end()) continue;
        BlockItem *toblockItem = toblockIt.value();

        QMap<QString, BlockPortItem* >::const_iterator toflowIt = toblockItem->ports().find(flowConnect->toflow());
        if(toflowIt==fromblockItem->ports().end()) continue;
        BlockPortItem *toflowItem = toflowIt.value();

        BlockConnectorItem *connectorItem = new BlockConnectorItem(fromflowItem, toflowItem);
        addItem(connectorItem);
    }

    return true;
}

bool BlockScene::loadFromCamera(const Camera *camera)
{
    clear();

    foreach (Block *block, camera->blocks())
    {
        //block->
    }

    return true;
}
