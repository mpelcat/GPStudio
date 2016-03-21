/****************************************************************************
** Copyright (C) 2014 Dream IP
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

#ifndef LIBTREEVIEW_H
#define LIBTREEVIEW_H

#include "gpstudio_gui_common.h"

#include <QMouseEvent>
#include <QTreeView>
#include "libitemmodel.h"

class GPSTUDIO_GUI_EXPORT LibTreeView : public QTreeView
{
    Q_OBJECT
public:
    explicit LibTreeView(QWidget *parent = 0);

    void setLib(const Lib *lib);

signals:

public slots:

protected:
    void startDrag(Qt::DropActions supportedActions);

private:
    LibItemModel *_model;
};

#endif // LIBTREEVIEW_H
