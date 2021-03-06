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

#ifndef VIEWERTREEVIEW_H
#define VIEWERTREEVIEW_H

#include "gpstudio_gui_common.h"

#include <QTreeView>
#include <QMouseEvent>

#include "cameraitemmodel.h"
#include "nodeeditor/gpnodeproject.h"

class GPSTUDIO_GUI_EXPORT ViewerTreeView : public QTreeView
{
    Q_OBJECT
public:
    ViewerTreeView();

    void attachProject(GPNodeProject *project);

signals:
    void viewerAdded(const QString viewerName);
    void viewerFlowAdded(const QString viewerName);

protected:
    void dragEnterEvent(QDragEnterEvent *event);
    void dragMoveEvent(QDragMoveEvent *event);
    void dropEvent(QDropEvent *event);

private:
    CameraItemModel *_model;
};

#endif // VIEWERTREEVIEW_H
