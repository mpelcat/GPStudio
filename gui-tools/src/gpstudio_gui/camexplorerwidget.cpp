#include "camexplorerwidget.h"

#include <QBoxLayout>

#include "camera/camera.h"

#include <QDebug>

CamExplorerWidget::CamExplorerWidget(QWidget *parent)
    : QWidget(parent)
{
    QLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);

    _camItemModel = new CameraItemModel();
    _camTreeView = new QTreeView();
    _camTreeView->setModel(_camItemModel);
    _camTreeView->setSortingEnabled(true);
    layout->addWidget(_camTreeView);

    _propertyItemModel = new PropertyItemModel();
    _propertyTreeView = new QTreeView();
    _propertyTreeView->setModel(_propertyItemModel);
    _propertyTreeView->setSortingEnabled(true);
    layout->addWidget(_propertyTreeView);

    connect(_camTreeView, SIGNAL(clicked(QModelIndex)), this, SLOT(updateRootProperty(QModelIndex)));
    connect(_camTreeView, SIGNAL(activated(QModelIndex)), this, SLOT(updateRootProperty(QModelIndex)));

    setLayout(layout);
}

Camera *CamExplorerWidget::camera() const
{
    return _camera;
}

void CamExplorerWidget::setCamera(Camera *camera)
{
    _camera = camera;
    _camItemModel->addCamera(camera);
    _camTreeView->expandToDepth(0);
    _camTreeView->resizeColumnToContents(0);
    _propertyItemModel->setRootProperty(&_camera->rootProperty());
}

void CamExplorerWidget::updateRootProperty(QModelIndex index)
{
    QModelIndex localMapToSource = _camItemModel->mapToSource(index);
    if(!localMapToSource.isValid())
        _propertyItemModel->setRootProperty(NULL);

    CameraItem *item = static_cast<CameraItem*>(localMapToSource.internalPointer());
    if(!item)
        _propertyItemModel->setRootProperty(NULL);

    switch (item->type())
    {
    case CameraItem::CameraType:
        _propertyItemModel->setRootProperty(&item->camera()->rootProperty());
        break;
    case CameraItem::BlockType:
        _propertyItemModel->setRootProperty(item->block()->assocProperty());
        break;
    case CameraItem::FlowType:
        _propertyItemModel->setRootProperty(item->flow()->assocProperty());
        break;
    default:
        _propertyItemModel->setRootProperty(NULL);
        break;
    }
}
