#ifndef PROCESSESVIEW_H
#define PROCESSESVIEW_H

#include "gpstudio_gui_common.h"

#include <QGraphicsView>

#include "processesscene.h"
class ProcessItem;

#include "model/node.h"
#include "lib_parser/lib.h"

class GPSTUDIO_GUI_EXPORT ProcessesView : public QGraphicsView
{
public:
    ProcessesView(QWidget *parent);
    ~ProcessesView();

    Lib *lib() const;
    void setLib(Lib *lib);

    bool loadFromNode(Node *node);

protected:
    void dragEnterEvent(QDragEnterEvent *event);
    void dragMoveEvent(QDragMoveEvent *event);
    void dropEvent(QDropEvent *event);

    void mousePressEvent(QMouseEvent *event);
    void mouseMoveEvent(QMouseEvent *event);
    void mouseReleaseEvent(QMouseEvent *event);

private:
    ProcessesScene *_scene;
    Lib *_lib;

    // connector system
    ProcessItem *_startConnectItem;
    QGraphicsLineItem *_lineConector;
};

#endif // PROCESSESVIEW_H
