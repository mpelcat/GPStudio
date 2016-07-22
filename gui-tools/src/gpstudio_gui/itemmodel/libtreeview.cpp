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

#include "libtreeview.h"

#include <QDebug>
#include <QDrag>
#include <QMimeData>
LibTreeView::LibTreeView(QWidget *parent) :
    QTreeView(parent)
{
    _model = new LibItemModel(this);
    setModel(_model);

    setSelectionMode(QAbstractItemView::SingleSelection);
    setDragEnabled(true);
    setDragDropMode(QAbstractItemView::DragOnly);

    connect(this, SIGNAL(doubleClicked(QModelIndex)), this, SLOT(doubleClickProcess(QModelIndex)));
}

void LibTreeView::setLib(const Lib *lib)
{
    _model->setLib(lib);

    resizeColumnToContents(0);
    resizeColumnToContents(1);
}

void LibTreeView::startDrag(Qt::DropActions supportedActions)
{
    Q_UNUSED(supportedActions);

    QDrag *drag = new QDrag(this);
    QMimeData *mimeData = new QMimeData;

    const BlockLib *proc = _model->processList()[currentIndex().data(Qt::UserRole).toInt()];

    mimeData->setText(proc->name());
    drag->setMimeData(mimeData);
    drag->setPixmap(proc->icon().pixmap(32,32));

    drag->exec();
}

void LibTreeView::doubleClickProcess(QModelIndex index)
{
    if(!index.isValid())
        return;

    const BlockLib *proc = _model->processList()[currentIndex().data(Qt::UserRole).toInt()];

    if(proc)
        emit processAdded(proc->name());
}
