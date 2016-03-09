#include "cameraitemmodel.h"

#include "camera/camera.h"

#include <QDebug>
#include <QIcon>

CameraItemModelNoSorted::CameraItemModelNoSorted(QObject *parent)
    : QAbstractItemModel(parent)
{
    _rootItem = new CameraItem();
}

CameraItemModelNoSorted::CameraItemModelNoSorted(Camera *camera, QObject *parent)
    : QAbstractItemModel(parent)
{
    _rootItem = new CameraItem();
    addCamera(camera);
}

QModelIndex CameraItemModelNoSorted::index(int row, int column, const QModelIndex &parent) const
{
    if (!hasIndex(row, column, parent))
            return QModelIndex();

    CameraItem *parentItem;

    if (!parent.isValid())
        parentItem = _rootItem;
    else
        parentItem = static_cast<CameraItem*>(parent.internalPointer());

    const CameraItem *childItem = parentItem->children(row);
    if (childItem)
        return createIndex(row, column, childItem->ptr());
    else
        return QModelIndex();
}

QModelIndex CameraItemModelNoSorted::parent(const QModelIndex &child) const
{
    if (!child.isValid())
        return QModelIndex();

    CameraItem *childItem = static_cast<CameraItem*>(child.internalPointer());
    CameraItem *parentItem = childItem->parent();

    if (parentItem == _rootItem)
        return QModelIndex();

    return createIndex(parentItem->row(), 0, parentItem);
}

int CameraItemModelNoSorted::rowCount(const QModelIndex &parent) const
{
    if (parent.column() > 0)
            return 0;

    if(!parent.isValid()) // root item
    {
        return _rootItem->count();
    }
    else
    {
        CameraItem *item = static_cast<CameraItem*>(parent.internalPointer());
        return item->count();
    }
    return 0;
}

int CameraItemModelNoSorted::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return ColumnCount;
}

QVariant CameraItemModelNoSorted::data(const QModelIndex &index, int role) const
{
    if(_rootItem->count()==0) return QVariant();

    CameraItem *item = static_cast<CameraItem*>(index.internalPointer());
    // ============== cam mode ==============
    switch (item->type())
    {
    case CameraItem::CameraType:
        switch (role)
        {
        case Qt::DisplayRole:
            switch (index.column())
            {
            case Name:
                return QVariant(item->camera()->node()->name());
            case Value:
                return QVariant("USB port 1.2");
            default:
                return QVariant();
            }
        case Qt::DecorationRole:
            if(index.column()==0)
            {
                return QIcon(":/icons/img/usb.png");
            }
        }
        return QVariant();
    case CameraItem::BlockType:
        switch (role)
        {
        case Qt::DisplayRole:
            switch (index.column())
            {
            case Name:
                return QVariant(item->block()->name());
            default:
                return QVariant();
            }
        }
        return QVariant();
    case CameraItem::FlowType:
        switch (role)
        {
        case Qt::DisplayRole:
            switch (index.column())
            {
            case Name:
                return QVariant(item->flow()->name());
            case Value:
                return QVariant("in");
            default:
                return QVariant();
            }
        case Qt::DecorationRole:
            if(index.column()==0)
            {
                if(item->flow()->type()==Flow::Input)
                    return QIcon(":/icons/img/flow-in.png");
                else
                    return QIcon(":/icons/img/flow-out.png");
            }
        }
        return QVariant();
    default:
        return QVariant();
    }

    return QVariant();
}

QVariant CameraItemModelNoSorted::headerData(int section, Qt::Orientation orientation, int role) const
{
    if(orientation==Qt::Vertical) return QVariant();
    switch (role)
    {
    case Qt::DisplayRole:
        switch (section)
        {
        case Name:
            return QVariant("Name");
        case Value:
            return QVariant("Value");
        default:
            return QVariant();
        }
        break;
    }
    return QVariant();
}

void CameraItemModelNoSorted::addCamera(const Camera *camera)
{
    emit layoutAboutToBeChanged();
    _rootItem->append(camera);
    emit layoutChanged();
}


// =============== sorted model ====================
CameraItemModel::CameraItemModel(QObject *parent)
{
    _modelCam = new CameraItemModelNoSorted(parent);
    setSourceModel(_modelCam);
}

CameraItemModel::CameraItemModel(Camera *camera, QObject *parent)
{
    _modelCam = new CameraItemModelNoSorted(camera, parent);
    setSourceModel(_modelCam);
    //setFilterWildcard("pro*");
}

void CameraItemModel::addCamera(const Camera *camera)
{
    emit layoutAboutToBeChanged();
    _modelCam->addCamera(camera);
    emit layoutChanged();
}
