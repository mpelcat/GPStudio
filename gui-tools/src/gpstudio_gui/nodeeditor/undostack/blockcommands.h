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
    BlockCommand(GPNodeProject *project, ModelBlock *block=NULL);

protected:
    GPNodeProject *_project;
    ModelBlock *_block;
};

class GPSTUDIO_GUI_EXPORT BlockCmdRename : public BlockCommand
{
public:
    enum { Id = 0x0101 };
    BlockCmdRename(GPNodeProject *project, ModelBlock *block, const QString &oldName, const QString &newName);
    void undo();
    void redo();
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
    BlockCmdMove(GPNodeProject *project, ModelBlock *block, const QPoint &oldPos, const QPoint &newPos);
    void undo();
    void redo();
    bool mergeWith(const QUndoCommand *command);
    int id() const { return Id; }

protected:
    QPoint _oldPos;
    QPoint _newPos;
};

class GPSTUDIO_GUI_EXPORT BlockCmdAdd : public BlockCommand
{
public:
    enum { Id = 0x0103 };
    BlockCmdAdd(GPNodeProject *project, ModelBlock *block);
    ~BlockCmdAdd();
    void undo();
    void redo();
    int id() const { return Id; }

protected:
    ModelBlock *_backupBlock;
};

class GPSTUDIO_GUI_EXPORT BlockCmdRemove : public BlockCommand
{
public:
    enum { Id = 0x0104 };
    BlockCmdRemove(GPNodeProject *project, ModelBlock *block);
    ~BlockCmdRemove();
    void undo();
    void redo();
    int id() const { return Id; }

protected:
    ModelBlock *_backupBlock;
};

class GPSTUDIO_GUI_EXPORT BlockCmdConnectFlow : public BlockCommand
{
public:
    enum { Id = 0x0105 };
    BlockCmdConnectFlow(GPNodeProject *project, ModelFlow *flow1, ModelFlow *flow2);
    void undo();
    void redo();
    int id() const { return Id; }

protected:
    ModelFlow *_flow1;
    ModelFlow *_flow2;
};

class GPSTUDIO_GUI_EXPORT BlockCmdDisconnectFlow : public BlockCommand
{
public:
    enum { Id = 0x0106 };
    BlockCmdDisconnectFlow(GPNodeProject *project, ModelFlow *flow1, ModelFlow *flow2);
    void undo();
    void redo();
    int id() const { return Id; }

protected:
    ModelFlow *_flow1;
    ModelFlow *_flow2;
};

#endif // BLOCKCOMMANDS_H
