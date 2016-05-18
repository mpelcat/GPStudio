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
class BlockConnectorItem;

#include "model/model_node.h"
#include "lib_parser/lib.h"

#include "nodeeditor/gpnodeproject.h"

class GPSTUDIO_GUI_EXPORT BlockView : public QGraphicsView
{
    Q_OBJECT
public:
    BlockView(QWidget *parent=NULL);
    ~BlockView();

    void attachProject(GPNodeProject *project);

    bool loadFromNode(const ModelNode *node);
    bool loadFromCam(const Camera *camera);

    BlockScene *blockScene() const;
    void setBlockScene(BlockScene *scene);

    bool editMode() const;
    void setEditMode(bool editMode);

protected:
    void dragEnterEvent(QDragEnterEvent *event);
    void dragMoveEvent(QDragMoveEvent *event);
    void dropEvent(QDropEvent *event);

    void mousePressEvent(QMouseEvent *event);
    void mouseMoveEvent(QMouseEvent *event);
    void mouseReleaseEvent(QMouseEvent *event);
    void mouseDoubleClickEvent(QMouseEvent * event);

    void setZoomLevel(int step);
    void wheelEvent(QWheelEvent *event);
    void keyPressEvent(QKeyEvent *event);
protected slots:
    void updateSelection();

public slots:
    void selectBlock(const Block *block);
    void changeNode(ModelNode *node);

    void updateBlock(ModelBlock *block);
    void addBlock(ModelBlock *block);
    void removeBlock(ModelBlock *block);
    void connectBlock(ModelFlow *fromFlow, ModelFlow *toFlow);
    void disconnectBlock(ModelFlow *fromFlow, ModelFlow *toFlow);

    void zoomIn();
    void zoomOut();
    void zoomFit();

signals:
    void blockSelected(const Block *block);
    void blockMoved(ModelBlock *block, QPoint newPos);
    void blockDetailsRequest(const Block *block);
    void blockPortConnected(ModelFlow *fromFlow, ModelFlow *toFlow);

private:
    GPNodeProject *_project;

    BlockScene *_scene;
    bool _editMode;

    // connector system
    BlockPortItem *_startConnectItem;
    BlockConnectorItem *_lineConector;
};

#endif // BLOCKVIEW_H
