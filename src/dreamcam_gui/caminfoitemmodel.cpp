#include "caminfoitemmodel.h"

#include "camera.h"

CamInfoItemModel::CamInfoItemModel(QObject *parent) :
    QAbstractItemModel(parent)
{
}

int CamInfoItemModel::columnCount(const QModelIndex &parent) const
{
    return ColumnCount;
}

QVariant CamInfoItemModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if(orientation==Qt::Vertical) return QVariant();
    switch (role)
    {
    case Qt::DisplayRole:
        switch (section)
        {
        case Name:
            return QVariant("Name");
        case Driver:
            return QVariant("Driver");
        case Adress:
            return QVariant("Adress");
        default:
            return QVariant();
        }
    break;
    }
    return QVariant();
}

QVariant CamInfoItemModel::data(const QModelIndex &index, int role) const
{
    if(index.row()>=_usbList.count()) return QVariant();

    const CameraInfo &cameraInfo = _usbList[index.row()];

    switch (role)
    {
    case Qt::DisplayRole:
        switch (index.column())
        {
        case Name:
            return QVariant(cameraInfo.name());
        case Driver:
            return QVariant(cameraInfo.driverType());
        case Adress:
            return QVariant(cameraInfo.addr());
        default:
            return QVariant();
        }
    case Qt::UserRole:
        return index.row();
    }
    return QVariant();
}

QModelIndex CamInfoItemModel::index(int row, int column, const QModelIndex &parent) const
{
    return createIndex(row, column);
}

QModelIndex CamInfoItemModel::parent(const QModelIndex &child) const
{
    return QModelIndex();
}

int CamInfoItemModel::rowCount(const QModelIndex &parent) const
{
    if(!parent.isValid()) return _usbList.count();
    return 0;
}

void CamInfoItemModel::refreshCams()
{
    emit layoutAboutToBeChanged();

    _usbList.clear();
    foreach(CameraInfo info, Camera::avaibleCams())
    {
        _usbList.append(info);
    }

    emit layoutChanged();
}

const QList<CameraInfo> &CamInfoItemModel::usbList() const
{
    return _usbList;
}
