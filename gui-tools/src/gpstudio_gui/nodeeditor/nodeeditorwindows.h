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

#ifndef NODEEDITORWINDOW_H
#define NODEEDITORWINDOW_H

#include "gpstudio_gui_common.h"

#include <QMainWindow>

#include "gpnodeproject.h"

#include "itemsview/blockview.h"
#include "itemmodel/libtreeview.h"

class GPSTUDIO_GUI_EXPORT NodeEditorWindows : public QMainWindow
{
    Q_OBJECT

public:
    explicit NodeEditorWindows(QWidget *parent=NULL, GPNodeProject *nodeProject=NULL);
    ~NodeEditorWindows();

    void attachProject(GPNodeProject *project);

protected:
    void closeEvent(QCloseEvent *event);

private slots:
    void configNode();

    void reloadNode();
    void reloadNodePath();

    void about();
    void aboutQt();

private:
    GPNodeProject *_project;

    void setupWidgets();
    BlockView *_blocksView;

    // docks
    void createDocks();
    QDockWidget *_libTreeViewDock;
    LibTreeView *_libTreeView;

    void createToolBarAndMenu();
    QToolBar *_mainToolBar;
};

#endif // NODEEDITORWINDOW_H
