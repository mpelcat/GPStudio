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

#ifndef BLOCKVIEW_H
#define BLOCKVIEW_H

#include "gpstudio_gui_common.h"

#include <QGraphicsView>

#include "blockscene.h"
class BlockItem;

#include "model/model_node.h"
#include "lib_parser/lib.h"

class GPSTUDIO_GUI_EXPORT BlockView : public QGraphicsView
{
public:
    BlockView(QWidget *parent);
    ~BlockView();

    Lib *lib() const;
    void setLib(Lib *lib);

    bool loadFromNode(const ModelNode *node);

protected:
    void dragEnterEvent(QDragEnterEvent *event);
    void dragMoveEvent(QDragMoveEvent *event);
    void dropEvent(QDropEvent *event);

    void mousePressEvent(QMouseEvent *event);
    void mouseMoveEvent(QMouseEvent *event);
    void mouseReleaseEvent(QMouseEvent *event);

private:
    BlockScene *_scene;
    Lib *_lib;

    // connector system
    BlockItem *_startConnectItem;
    QGraphicsLineItem *_lineConector;
};

#endif // BLOCKVIEW_H
