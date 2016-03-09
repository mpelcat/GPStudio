#ifndef CAMEXPLORERWIDGET_H
#define CAMEXPLORERWIDGET_H

#include "gpstudio_gui_common.h"

#include <QWidget>

#include "propertyitemmodel.h"
#include "cameraitemmodel.h"
#include <QTreeView>

class GPSTUDIO_GUI_EXPORT CamExplorerWidget : public QWidget
{
    Q_OBJECT
public:
    CamExplorerWidget(QWidget *parent=0);

    Camera *camera() const;
    void setCamera(Camera *camera);

protected slots:
    void updateRootProperty(QModelIndex index);

private:
    QTreeView *_camTreeView;
    CameraItemModel *_camItemModel;

    QTreeView *_propertyTreeView;
    PropertyItemModel *_propertyItemModel;

    Camera *_camera;
};

#endif // CAMEXPLORERWIDGET_H
