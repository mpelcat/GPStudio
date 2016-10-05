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

    _blocksName.clear();
    _blocksModel.clear();
    clear();

    foreach (ModelBlock *modelBlock, node->blocks())
    {
        if(modelBlock->name()!="pi" && modelBlock->name()!="fi" && modelBlock->name()!="ci")
            addBlock(modelBlock);
    }

    ModelFIBlock *fiBlock = node->getFIBlock();
    if(fiBlock)
        connectBlockPorts(fiBlock->flowConnects());

    return true;
}

bool BlockScene::loadFromCamera(const Camera *camera)
{
    if(!camera)
        return false;

    _blocksName.clear();
    _blocksModel.clear();
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

void BlockScene::addBlock(ModelBlock *blockModel)
{
    QList<BlockItem *> blockItems = BlockItem::fromModelBlock(blockModel);
    foreach (BlockItem *blockItem, blockItems)
    {
        _blocksName.insertMulti(blockModel->name(), blockItem);
        _blocksModel.insertMulti(blockModel, blockItem);
        addItem(blockItem);
    }
}

void BlockScene::addBlock(Block *block)
{
    QList<BlockItem *> blockItems = BlockItem::fromBlock(block);
    foreach (BlockItem *blockItem, blockItems)
    {
        _blocksName.insertMulti(block->modelBlock()->name(), blockItem);
        _blocksModel.insertMulti(block->modelBlock(), blockItem);
        addItem(blockItem);
    }
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

void BlockScene::removeBlock(const QString &block_name)
{
    foreach(BlockItem *blockItem, block(block_name))
    {
        removeItem(blockItem);
        _blocksName.remove(block_name);
        _blocksModel.remove(blockItem->modelBlock());
    }
}

QList<BlockItem *>BlockScene::block(const QString &name) const
{
    return _blocksName.values(name);
}

BlockPortItem *BlockScene::port(const QString &blockName, const QString &portName) const
{
    foreach(BlockItem *blockItem, block(blockName))
    {
        BlockPortItem *fromflowItem = blockItem->port(portName);
        if(fromflowItem)
            return fromflowItem;
    }
    return NULL;
}

BlockItem *BlockScene::block(ModelBlock *modelBlock) const
{
    QMap<ModelBlock*, BlockItem* >::const_iterator it = _blocksModel.find(modelBlock);
    if(it != _blocksModel.end())
        return it.value();
    return NULL;
}

void BlockScene::connectBlockPort(const ModelFlowConnect &flowConnect)
{
    connectBlockPort(flowConnect.fromblock(), flowConnect.fromflow(), flowConnect.toblock(), flowConnect.toflow());
}

void BlockScene::connectBlockPort(ModelFlow *fromflow, ModelFlow *toflow)
{
    connectBlockPort(fromflow->parent()->name(), fromflow->name(), toflow->parent()->name(), toflow->name());
}

void BlockScene::connectBlockPort(const QString &fromblock, const QString &fromflow, const QString &toblock, const QString &toflow)
{
    BlockPortItem *fromflowItem = port(fromblock, fromflow);
    if(!fromflowItem)
        return;

    BlockPortItem *toflowItem = port(toblock, toflow);
    if(!toflowItem)
        return;

    connectBlockPort(fromflowItem, toflowItem);
}

void BlockScene::disconnectBlockPort(const ModelFlowConnect &flowConnect)
{
    disconnectBlockPort(flowConnect.fromblock(), flowConnect.fromflow(), flowConnect.toblock(), flowConnect.toflow());
}

void BlockScene::disconnectBlockPort(ModelFlow *fromFlow, ModelFlow *toFlow)
{
    if(fromFlow==NULL || toFlow==NULL)
        return;

    disconnectBlockPort(fromFlow->parent()->name(), fromFlow->name(), toFlow->parent()->name(), toFlow->name());
}

void BlockScene::disconnectBlockPort(const QString &fromblock, const QString &fromflow, const QString &toblock, const QString &toflow)
{
    BlockPortItem *fromflowItem = port(fromblock, fromflow);
    if(!fromflowItem)
        return;

    BlockPortItem *toflowItem = port(toblock, toflow);
    if(!toflowItem)
        return;

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
        BlockPortItem *fromflowItem = port(flowConnect->fromblock(), flowConnect->fromflow());
        if(!fromflowItem)
            continue;

        BlockPortItem *toflowItem = port(flowConnect->toblock(), flowConnect->toflow());
        if(!toflowItem)
            continue;

        BlockConnectorItem *connectorItem = new BlockConnectorItem(fromflowItem, toflowItem);
        addItem(connectorItem);
    }
}
