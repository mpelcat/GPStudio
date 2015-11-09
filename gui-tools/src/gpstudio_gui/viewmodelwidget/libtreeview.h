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
