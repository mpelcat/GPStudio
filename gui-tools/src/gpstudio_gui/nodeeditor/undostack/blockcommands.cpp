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
    setText(QString("added block '%1'").arg(block->name()));
}

BlockCmdAdd::~BlockCmdAdd()
{
    // delete the block if it's not inside the node
    if(!_project->node()->blocks().contains(_block))
        delete _block;
}

void BlockCmdAdd::undo()
{
    _project->cmdRemoveBlock(_block);
}

void BlockCmdAdd::redo()
{
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
    // delete the block if it's not inside the node
    if(!_project->node()->blocks().contains(_block))
        delete _block;
}

void BlockCmdRemove::undo()
{
    _project->cmdAddBlock(_block);
}

void BlockCmdRemove::redo()
{
    _project->cmdRemoveBlock(_block);
}

// Flow connection
BlockCmdConnectFlow::BlockCmdConnectFlow(GPNodeProject *project, ModelFlow *flow1, ModelFlow *flow2)
    : BlockCommand(project), _flow1(flow1), _flow2(flow2)
{
    setText(QString("connect flow '%1.%2' to '%3.%4'")
            .arg(flow1->parent()->name()).arg(flow1->name())
            .arg(flow2->parent()->name()).arg(flow2->name()));
}

void BlockCmdConnectFlow::undo()
{
    _project->cmdDisconnectFlow(_flow1, _flow2);
}

void BlockCmdConnectFlow::redo()
{
    _project->cmdConnectFlow(_flow1, _flow2);
}

// Flow disconnection
BlockCmdDisconnectFlow::BlockCmdDisconnectFlow(GPNodeProject *project, ModelFlow *flow1, ModelFlow *flow2)
    : BlockCommand(project), _flow1(flow1), _flow2(flow2)
{
    setText(QString("disconnect flow '%1.%2' to '%3.%4'")
            .arg(flow1->parent()->name()).arg(flow1->name())
            .arg(flow2->parent()->name()).arg(flow2->name()));
}

void BlockCmdDisconnectFlow::undo()
{
    _project->cmdConnectFlow(_flow1, _flow2);
}

void BlockCmdDisconnectFlow::redo()
{
    _project->cmdDisconnectFlow(_flow1, _flow2);
}
