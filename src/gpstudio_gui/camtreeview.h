#ifndef CAMTREEVIEW_H
#define CAMTREEVIEW_H

#include "gpstudio_gui_common.h"

#include <QTreeView>
#include "caminfoitemmodel.h"

class GPSTUDIO_GUI_EXPORT CamTreeView : public QTreeView
{
    Q_OBJECT
public:
    explicit CamTreeView(QWidget *parent = 0);

    void refreshCams();

signals:
    void cameraSelected(CameraInfo cameraInfo);

public slots:

private slots:
    void cameraSelect(QModelIndex index);

private:
    CamInfoItemModel *_model;
};

#endif // CAMTREEVIEW_H
