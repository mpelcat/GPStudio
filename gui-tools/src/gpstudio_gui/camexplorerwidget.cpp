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
    CameraItem *item = static_cast<CameraItem*>(_camItemModel->mapToSource(index).internalPointer());

    qDebug()<<_camItemModel->sourceModel()->data(_camItemModel->mapToSource(index))<<item->type();

    switch (item->type())
    {
    case CameraItem::CameraType:
        qDebug()<<"select cam";
        _propertyItemModel->setRootProperty(&item->camera()->rootProperty());
        break;
    case CameraItem::BlockType:
        qDebug()<<"select block";
        _propertyItemModel->setRootProperty(item->block()->assocProperty());
        break;
    case CameraItem::FlowType:
        qDebug()<<"select flow";
        _propertyItemModel->setRootProperty(item->flow()->assocProperty());
        break;
    default:
        _propertyItemModel->setRootProperty(NULL);
        break;
    }
}
