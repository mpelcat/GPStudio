#include "libitemmodel.h"

LibItemModel::LibItemModel(QObject *parent) :
    QAbstractItemModel(parent)
{
}

int LibItemModel::columnCount(const QModelIndex &parent) const
{
    return ColumnCount;
}

QVariant LibItemModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if(orientation==Qt::Vertical) return QVariant();
    switch (role)
    {
    case Qt::DisplayRole:
        switch (section)
        {
        case Name:
            return QVariant("Name");
        case Description:
            return QVariant("Description");
        default:
            return QVariant();
        }
    break;
    }
    return QVariant();
}

QVariant LibItemModel::data(const QModelIndex &index, int role) const
{
    if(index.row()>=_processList.count()) return QVariant();

    const ProcessLib &processLib = _processList[index.row()];

    switch (role)
    {
    case Qt::DisplayRole:
        switch (index.column())
        {
        case Name:
            return QVariant(processLib.name());
        case Description:
            return QVariant(processLib.description());
        default:
            return QVariant();
        }
    case Qt::DecorationRole:
        if(index.column()==Name)
            return QVariant(processLib.icon());
        break;
    case Qt::ToolTipRole:
        return QVariant(processLib.description());
    case Qt::UserRole:
        return index.row();
    }
    return QVariant();
}

QModelIndex LibItemModel::index(int row, int column, const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return createIndex(row, column);
}

QModelIndex LibItemModel::parent(const QModelIndex &child) const
{
    Q_UNUSED(child);
    return QModelIndex();
}

int LibItemModel::rowCount(const QModelIndex &parent) const
{
    if(!parent.isValid()) return _processList.count();
    return 0;
}

Qt::ItemFlags LibItemModel::flags(const QModelIndex &index) const
{
    Qt::ItemFlags defaultFlags = QAbstractItemModel::flags(index);

    if (index.isValid())
        return Qt::ItemIsDragEnabled | defaultFlags;
    else
        return defaultFlags;
}

void LibItemModel::setLib(const Lib *lib)
{
    emit layoutAboutToBeChanged();

    _processList.clear();
    foreach(ProcessLib *processLib, lib->processes())
    {
        _processList.append(*processLib);
    }

    emit layoutChanged();
}

QList<ProcessLib> LibItemModel::processList() const
{
    return _processList;
}
