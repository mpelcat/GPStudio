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
    : _block(block), _project(project)
{
}

// Rename block
BlockCmdRename::BlockCmdRename(GPNodeProject *project, ModelBlock *block, QString oldName, QString newName)
    : BlockCommand(project, block), _oldName(oldName), _newName(newName)
{
}

bool BlockCmdRename::mergeWith(const QUndoCommand *command)
{
    return false;
}

// Move block
BlockCmdMove::BlockCmdMove(GPNodeProject *project, ModelBlock *block, QPoint oldPos, QPoint newPos)
    : BlockCommand(project, block), _oldPos(oldPos), _newPos(newPos)
{
}

void BlockCmdMove::undo()
{
    _block->setPos(_oldPos);
    _project->updateBlock(_block);
}

void BlockCmdMove::redo()
{
    _block->setPos(_newPos);
    _project->updateBlock(_block);
}

bool BlockCmdMove::mergeWith(const QUndoCommand *command)
{
    const BlockCmdMove *blockCmdMove = static_cast<const BlockCmdMove *>(command);

    if (_block != blockCmdMove->_block)
        return false;

    _newPos = blockCmdMove->_newPos;

    return true;
}
