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

#ifndef BLOCKCOMMANDS_H
#define BLOCKCOMMANDS_H

#include "gpstudio_gui_common.h"

#include <QUndoCommand>

#include "nodeeditor/gpnodeproject.h"
#include "model/model_block.h"

class GPSTUDIO_GUI_EXPORT BlockCommand : public QUndoCommand
{
public:
    BlockCommand(GPNodeProject *project, ModelBlock *block);

protected:
    GPNodeProject *_project;
    ModelBlock *_block;
};

class GPSTUDIO_GUI_EXPORT BlockCmdRename : public BlockCommand
{
public:
    enum { Id = 0x0101 };
    BlockCmdRename(GPNodeProject *project, ModelBlock *block, QString oldName, QString newName);
    bool mergeWith(const QUndoCommand *command);
    int id() const { return Id; }

protected:
    QString _oldName;
    QString _newName;
};

class GPSTUDIO_GUI_EXPORT BlockCmdMove : public BlockCommand
{
public:
    enum { Id = 0x0102 };
    BlockCmdMove(GPNodeProject *project, ModelBlock *block, QPoint oldPos, QPoint newPos);
    void undo();
    void redo();
    bool mergeWith(const QUndoCommand *command);
    int id() const { return Id; }

protected:
    QPoint _oldPos;
    QPoint _newPos;
};

#endif // BLOCKCOMMANDS_H
