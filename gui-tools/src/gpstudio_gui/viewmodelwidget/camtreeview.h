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

    CameraInfo camInfoSelected() const;

signals:
    void cameraSelected(CameraInfo cameraInfo);

public slots:
    void refreshCams();

private slots:
    void cameraSelect(QModelIndex index);

private:
    CamInfoItemModel *_model;
};

#endif // CAMTREEVIEW_H
