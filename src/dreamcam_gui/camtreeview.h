#ifndef CAMTREEVIEW_H
#define CAMTREEVIEW_H

#include <QTreeView>

#include "dreamcam_gui.h"
#include "caminfoitemmodel.h"

class DREAMCAMGUI_EXPORT CamTreeView : public QTreeView
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
