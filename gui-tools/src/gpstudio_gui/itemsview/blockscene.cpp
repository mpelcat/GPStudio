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
    if(!node)
        return false;

    clear();

    foreach (ModelBlock *modelBlock, node->blocks())
    {
        if(modelBlock->name()!="pi" && modelBlock->name()!="fi" && modelBlock->name()!="ci")
            addBlock(modelBlock);
    }

    if(node->getFIBlock())
        connectBlocks(node->getFIBlock()->flowConnects());

    return true;
}

bool BlockScene::loadFromCamera(const Camera *camera)
{
    clear();

    foreach (Block *block, camera->blocks())
    {
        if(block->name()!="pi" && block->name()!="fi" && block->name()!="ci")
            addBlock(block->modelBlock());
    }

    if(camera->node()->getFIBlock())
        connectBlocks(camera->node()->getFIBlock()->flowConnects());

    return true;
}

void BlockScene::addBlock(ModelBlock *blockModel)
{
    BlockItem *blockItem = BlockItem::fromModelBlock(blockModel);
    _blocksName.insert(blockModel->name(), blockItem);
    _blocksModel.insert(blockModel, blockItem);
    addItem(blockItem);
}

BlockItem *BlockScene::block(const QString &name) const
{
    QMap<QString, BlockItem* >::const_iterator it = _blocksName.find(name);
    if(it != _blocksName.end())
        return it.value();
    return NULL;
}

BlockItem *BlockScene::block(ModelBlock *modelBlock) const
{
    QMap<ModelBlock*, BlockItem* >::const_iterator it = _blocksModel.find(modelBlock);
    if(it != _blocksModel.end())
        return it.value();
    return NULL;
}

void BlockScene::connectBlocks(const QList<ModelFlowConnect *> &connections)
{
    foreach (ModelFlowConnect *flowConnect, connections)
    {
        BlockItem *fromblockItem = block(flowConnect->fromblock());
        if(!fromblockItem) continue;

        BlockPortItem *fromflowItem = fromblockItem->port(flowConnect->fromflow());
        if(!fromflowItem) continue;

        BlockItem *toblockItem = block(flowConnect->toblock());
        if(!toblockItem) continue;

        BlockPortItem *toflowItem = toblockItem->port(flowConnect->toflow());
        if(!toflowItem) continue;

        BlockConnectorItem *connectorItem = new BlockConnectorItem(fromflowItem, toflowItem);
        addItem(connectorItem);
    }
}
