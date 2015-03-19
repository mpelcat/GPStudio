#ifndef PROCESSESVIEW_H
#define PROCESSESVIEW_H

#include "gpstudio_gui_common.h"

#include <QGraphicsView>

#include "processesscene.h"
#include "lib_parser/lib.h"

class GPSTUDIO_GUI_EXPORT ProcessesView : public QGraphicsView
{
public:
    ProcessesView(QWidget *parent);
    ~ProcessesView();

    Lib *lib() const;
    void setLib(Lib *lib);

protected:
    void dragEnterEvent(QDragEnterEvent *event);
    void dragMoveEvent(QDragMoveEvent *event);
    void dropEvent(QDropEvent *event);

private:
    ProcessesScene *_scene;
    Lib *_lib;
};

#endif // PROCESSESVIEW_H
