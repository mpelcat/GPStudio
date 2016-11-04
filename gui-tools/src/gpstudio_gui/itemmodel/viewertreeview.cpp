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

#include "viewertreeview.h"

#include <QDebug>
#include <QMimeData>

ViewerTreeView::ViewerTreeView()
{

}

void ViewerTreeView::attachProject(GPNodeProject *project)
{

}

void ViewerTreeView::dragEnterEvent(QDragEnterEvent *event)
{
    QTreeView::dragEnterEvent(event);

    if(event->mimeData()->hasFormat("flow/flowid"))
        event->accept();
}

void ViewerTreeView::dragMoveEvent(QDragMoveEvent *event)
{
    QTreeView::dragMoveEvent(event);

    if(event->mimeData()->hasFormat("flow/flowid"))
        event->accept();
}

void ViewerTreeView::dropEvent(QDropEvent *event)
{
    QTreeView::dropEvent(event);

    QString flow = event->mimeData()->data("flow/flowid");
    //QPoint pos = mapToScene(event->pos()).toPoint();

    //emit blockAdded(driver, pos);
    qDebug()<<Q_FUNC_INFO<<flow<<selectedIndexes();

    // viewerAdded
    // viewerFlowAdded
}
