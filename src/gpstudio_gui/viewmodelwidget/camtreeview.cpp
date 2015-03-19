#include "camtreeview.h"

CamTreeView::CamTreeView(QWidget *parent) :
    QTreeView(parent)
{
    _model = new CamInfoItemModel();
    setModel(_model);

    connect(this, SIGNAL(doubleClicked(QModelIndex)), this, SLOT(cameraSelect(QModelIndex)));

    refreshCams();
}

void CamTreeView::refreshCams()
{
    _model->refreshCams();
    resizeColumnToContents(0);
    resizeColumnToContents(1);
    resizeColumnToContents(2);
}

CameraInfo CamTreeView::camInfoSelected() const
{
    if(!currentIndex().isValid()) return CameraInfo();
    return _model->usbList()[currentIndex().row()];
}

void CamTreeView::cameraSelect(QModelIndex index)
{
    if(!index.isValid()) return;

    emit cameraSelected(_model->usbList()[index.row()]);
}
