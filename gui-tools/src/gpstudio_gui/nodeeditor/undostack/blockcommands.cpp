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

#include "blockcommands.h"

#include <QDebug>

#include "model/model_fiblock.h"
#include "model/model_process.h"
#include "model/model_iocom.h"

BlockCommand::BlockCommand(GPNodeProject *project, ModelBlock *block)
    : _project(project), _block(block)
{
}

// Rename block
BlockCmdRename::BlockCmdRename(GPNodeProject *project, ModelBlock *block, const QString &oldName, const QString &newName)
    : BlockCommand(project, block), _oldName(oldName), _newName(newName)
{
    setText(QString("renamed block '%1'").arg(newName));
}

void BlockCmdRename::undo()
{
    _project->cmdRenameBlock(_block, _oldName);
}

void BlockCmdRename::redo()
{
    _project->cmdRenameBlock(_block, _newName);
}

bool BlockCmdRename::mergeWith(const QUndoCommand *command)
{
    const BlockCmdRename *blockCmdRename = static_cast<const BlockCmdRename *>(command);

    if (_block != blockCmdRename->_block)
        return false;

    _newName = blockCmdRename->_newName;

    return true;
}

// Move block
BlockCmdMove::BlockCmdMove(GPNodeProject *project, ModelBlock *block, const QPoint &oldPos, const QPoint &newPos)
    : BlockCommand(project, block), _oldPos(oldPos), _newPos(newPos)
{
    setText(QString("moved block '%1'").arg(block->name()));
}

void BlockCmdMove::undo()
{
    _project->cmdMoveBlockTo(_block, _oldPos);
}

void BlockCmdMove::redo()
{
    _project->cmdMoveBlockTo(_block, _newPos);
}

bool BlockCmdMove::mergeWith(const QUndoCommand *command)
{
    const BlockCmdMove *blockCmdMove = static_cast<const BlockCmdMove *>(command);

    if (_block != blockCmdMove->_block)
        return false;

    _newPos = blockCmdMove->_newPos;

    return true;
}

// Add block
BlockCmdAdd::BlockCmdAdd(GPNodeProject *project, ModelBlock *block)
    : BlockCommand(project, block)
{
    _backupBlock = block;
    setText(QString("added block '%1'").arg(block->name()));
}

BlockCmdAdd::~BlockCmdAdd()
{
    delete _backupBlock;
}

void BlockCmdAdd::undo()
{
    // backup block
    if(_block->type()=="process")
        _backupBlock = new ModelProcess(*static_cast<ModelProcess*>(_block));
    else if(_block->type()=="io")
        _backupBlock = new ModelIO(*static_cast<ModelIO*>(_block));
    else if(_block->type()=="iocom")
        _backupBlock = new ModelIOCom(*static_cast<ModelIOCom*>(_block));

    _project->cmdRemoveBlock(_block);
}

void BlockCmdAdd::redo()
{
    _block = _backupBlock;
    _backupBlock = NULL;
    _project->cmdAddBlock(_block);
}

// Remove block
BlockCmdRemove::BlockCmdRemove(GPNodeProject *project, ModelBlock *block)
    : BlockCommand(project, block)
{
    setText(QString("remove block '%1'").arg(block->name()));
}

BlockCmdRemove::~BlockCmdRemove()
{
    delete _backupBlock;
}

void BlockCmdRemove::undo()
{
    _block = _backupBlock;
    _project->cmdAddBlock(_block);
    _backupBlock = NULL;

    foreach (ModelFlowConnect flowConnect, _flowConnects)
        _project->cmdConnectFlow(flowConnect);
}

void BlockCmdRemove::redo()
{
    // backup block
    if(_block->type()=="process")
        _backupBlock = new ModelProcess(*static_cast<ModelProcess*>(_block));
    else if(_block->type()=="io")
        _backupBlock = new ModelIO(*static_cast<ModelIO*>(_block));
    else if(_block->type()=="iocom")
        _backupBlock = new ModelIOCom(*static_cast<ModelIOCom*>(_block));

    // backup connection to/from block
    _flowConnects.clear();
    QList<ModelFlowConnect *> _flowConnectsPtr;
    _flowConnectsPtr = _project->node()->getFIBlock()->flowConnects(_block->name());
    foreach (ModelFlowConnect *flowConnect, _flowConnectsPtr)
        _flowConnects.append(*flowConnect);

    _project->cmdRemoveBlock(_block);
}

// Flow connection
BlockCmdConnectFlow::BlockCmdConnectFlow(GPNodeProject *project, const ModelFlowConnect &flowConnect)
    : BlockCommand(project), _flowConnect(flowConnect)
{
    setText(QString("connect flow '%1.%2' to '%3.%4'")
            .arg(flowConnect.fromblock()).arg(flowConnect.fromflow())
            .arg(flowConnect.toblock()).arg(flowConnect.toflow()));
}

void BlockCmdConnectFlow::undo()
{
    _project->cmdDisconnectFlow(_flowConnect);
}

void BlockCmdConnectFlow::redo()
{
    _project->cmdConnectFlow(_flowConnect);
}

// Flow disconnection
BlockCmdDisconnectFlow::BlockCmdDisconnectFlow(GPNodeProject *project, const ModelFlowConnect &flowConnect)
    : BlockCommand(project), _flowConnect(flowConnect)
{
    setText(QString("disconnect flow '%1.%2' to '%3.%4'")
            .arg(flowConnect.fromblock()).arg(flowConnect.fromflow())
            .arg(flowConnect.toblock()).arg(flowConnect.toflow()));
}

void BlockCmdDisconnectFlow::undo()
{
    _project->cmdConnectFlow(_flowConnect);
}

void BlockCmdDisconnectFlow::redo()
{
    _project->cmdDisconnectFlow(_flowConnect);
}
