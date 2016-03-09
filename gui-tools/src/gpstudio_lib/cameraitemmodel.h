#ifndef CAMERAITEMMODEL_H
#define CAMERAITEMMODEL_H

#include "gpstudio_lib_common.h"

#include "cameraitem.h"

#include <QAbstractItemModel>
#include <QSortFilterProxyModel>

class Camera;

class GPSTUDIO_LIB_EXPORT CameraItemModelNoSorted : public QAbstractItemModel
{
    Q_OBJECT
public:
    explicit CameraItemModelNoSorted(QObject *parent = 0);
    CameraItemModelNoSorted(Camera *camera, QObject *parent = 0);

    enum Column {
        Name,
        Value,
        ColumnCount
    };

    void addCamera(const Camera *camera);

    // QAbstractItemModel interface
public:
    // Header:
    QVariant headerData(int section, Qt::Orientation orientation, int role) const;

    // Basic functionality:
    QModelIndex index(int row, int column, const QModelIndex &parent) const;
    QModelIndex parent(const QModelIndex &child) const;

    int rowCount(const QModelIndex &parent) const;
    int columnCount(const QModelIndex &parent) const;

    QVariant data(const QModelIndex &index, int role=Qt::DisplayRole) const;

private:
    CameraItem *_rootItem;
};

class GPSTUDIO_LIB_EXPORT CameraItemModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit CameraItemModel(QObject *parent = 0);
    CameraItemModel(Camera *camera, QObject *parent = 0);

    void addCamera(const Camera *camera);

private:
    CameraItemModelNoSorted *_modelCam;
};

#endif // CAMERAITEMMODEL_H
