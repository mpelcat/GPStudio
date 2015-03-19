#ifndef CAMINFOITEMMODEL_H
#define CAMINFOITEMMODEL_H

#include "gpstudio_gui_common.h"

#include <QAbstractItemModel>
#include <QList>

#include "camerainfo.h"

class GPSTUDIO_GUI_EXPORT CamInfoItemModel : public QAbstractItemModel
{
    Q_OBJECT
public:
    explicit CamInfoItemModel(QObject *parent = 0);

    enum Column {
        Name,
        Driver,
        Adress,
        ColumnCount
    };

    int columnCount(const QModelIndex &parent) const;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const;
    QVariant data(const QModelIndex &index, int role) const;
    QModelIndex index(int row, int column, const QModelIndex &parent) const;
    QModelIndex parent(const QModelIndex &child) const;
    int rowCount(const QModelIndex &parent) const;

    void refreshCams();

    const QList<CameraInfo> &usbList() const;

signals:

public slots:

private:
    QList<CameraInfo> _usbList;
};

#endif // CAMINFOITEMMODEL_H
