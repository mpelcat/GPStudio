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

#include "viewercommands.h"

#include "model/model_gpviewer.h"

ViewerCommand::ViewerCommand(GPNodeProject *project, const QString &viewer_name)
    : _project(project), _viewer_name(viewer_name)
{
}

// Rename viewer
ViewerCmdRename::ViewerCmdRename(GPNodeProject *project, const QString &oldName, const QString &newName)
    : ViewerCommand(project, oldName), _newName(newName)
{
    setText(QString("renamed viewer '%1'").arg(newName));
}

void ViewerCmdRename::undo()
{
    _project->cmdRenameViewer(_newName, _viewer_name);
}

void ViewerCmdRename::redo()
{
    _project->cmdRenameViewer(_viewer_name, _newName);
}

// Add viewer
ViewerCmdAdd::ViewerCmdAdd(GPNodeProject *project, ModelViewer *viewer)
    : ViewerCommand(project, viewer->name()), _viewer(viewer)
{
    _backupViewer = viewer;
    setText(QString("add viewer '%1'").arg(viewer->name()));
}

ViewerCmdAdd::~ViewerCmdAdd()
{
    delete _backupViewer;
}

void ViewerCmdAdd::undo()
{
    ModelViewer *viewer = _project->node()->gpViewer()->getViewer(_viewer_name);
    if(viewer)
    {
        _backupViewer = new ModelViewer(*viewer);
    }
    _project->cmdRemoveViewer(_viewer_name);
}

void ViewerCmdAdd::redo()
{
    _viewer = _backupViewer;
    _backupViewer = NULL;
    _project->cmdAddViewer(_viewer);
}

// Remove viewer
ViewerCmdRemove::ViewerCmdRemove(GPNodeProject *project, ModelViewer *viewer)
    : ViewerCommand(project, viewer->name()), _viewer(viewer)
{
    setText(QString("remove viewer '%1'").arg(viewer->name()));
}

ViewerCmdRemove::~ViewerCmdRemove()
{
    delete _backupViewer;
}

void ViewerCmdRemove::undo()
{
    _viewer = _backupViewer;
    _backupViewer = NULL;
    _project->cmdAddViewer(_viewer);
}

void ViewerCmdRemove::redo()
{
    ModelViewer *viewer = _project->node()->gpViewer()->getViewer(_viewer_name);
    if(viewer)
    {
        _backupViewer = new ModelViewer(*viewer);
    }
    _project->cmdRemoveViewer(_viewer_name);
}
