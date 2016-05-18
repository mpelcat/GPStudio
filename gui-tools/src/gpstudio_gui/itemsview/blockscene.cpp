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
#include "blockportitem.h"

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
        connectBlockPorts(node->getFIBlock()->flowConnects());

    return true;
}

bool BlockScene::loadFromCamera(const Camera *camera)
{
    clear();

    foreach (Block *block, camera->blocks())
    {
        if(block->name()!="pi" && block->name()!="fi" && block->name()!="ci")
            addBlock(block);
    }

    if(camera->node()->getFIBlock())
        connectBlockPorts(camera->node()->getFIBlock()->flowConnects());

    return true;
}

BlockItem *BlockScene::addBlock(ModelBlock *blockModel)
{
    BlockItem *blockItem = BlockItem::fromModelBlock(blockModel);
    _blocksName.insert(blockModel->name(), blockItem);
    _blocksModel.insert(blockModel, blockItem);
    addItem(blockItem);
    return blockItem;
}

BlockItem *BlockScene::addBlock(Block *block)
{
    BlockItem *blockItem = BlockItem::fromBlock(block);
    _blocksName.insert(block->modelBlock()->name(), blockItem);
    _blocksModel.insert(block->modelBlock(), blockItem);
    addItem(blockItem);
    return blockItem;
}

void BlockScene::removeBlock(ModelBlock *blockModel)
{
    BlockItem *blockItem = block(blockModel);
    if(blockItem)
    {
        removeItem(blockItem);
        _blocksName.remove(blockModel->name());
        _blocksModel.remove(blockModel);
    }
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

void BlockScene::connectBlockPort(ModelFlow *fromflow, ModelFlow *toflow)
{
    connectBlockPort(fromflow->parent()->name(), fromflow->name(), toflow->parent()->name(), toflow->name());
}

void BlockScene::connectBlockPort(const QString &fromblock, const QString &fromflow, const QString &toblock, const QString &toflow)
{
    BlockItem *fromblockItem = block(fromblock);
    if(!fromblockItem) return;

    BlockPortItem *fromflowItem = fromblockItem->port(fromflow);
    if(!fromflowItem) return;

    BlockItem *toblockItem = block(toblock);
    if(!toblockItem) return;

    BlockPortItem *toflowItem = toblockItem->port(toflow);
    if(!toflowItem) return;

    connectBlockPort(fromflowItem, toflowItem);
}

void BlockScene::disconnectBlockPort(ModelFlow *fromflow, ModelFlow *toflow)
{
    disconnectBlockPort(fromflow->parent()->name(), fromflow->name(), toflow->parent()->name(), toflow->name());
}

void BlockScene::disconnectBlockPort(const QString &fromblock, const QString &fromflow, const QString &toblock, const QString &toflow)
{
    BlockItem *fromblockItem = block(fromblock);
    if(!fromblockItem) return;

    BlockPortItem *fromflowItem = fromblockItem->port(fromflow);
    if(!fromflowItem) return;

    BlockItem *toblockItem = block(toblock);
    if(!toblockItem) return;

    BlockPortItem *toflowItem = toblockItem->port(toflow);
    if(!toflowItem) return;

    foreach (BlockConnectorItem *connectorItem, fromflowItem->connects())
    {
        if((connectorItem->portItem1()==fromflowItem || connectorItem->portItem2()==fromflowItem) &&
           (connectorItem->portItem1()==toflowItem || connectorItem->portItem2()==toflowItem))
        {
            connectorItem->disconnectPorts();
            removeItem(connectorItem);
            delete connectorItem;
        }
    }
}

void BlockScene::connectBlockPort(BlockPortItem *fromflowItem, BlockPortItem *toflowItem)
{
    BlockConnectorItem *connectorItem = new BlockConnectorItem(fromflowItem, toflowItem);
    addItem(connectorItem);
}

void BlockScene::connectBlockPorts(const QList<ModelFlowConnect *> &connections)
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
