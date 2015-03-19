#ifndef LIBITEMMODEL_H
#define LIBITEMMODEL_H

#include "gpstudio_gui_common.h"

#include <QAbstractItemModel>
#include <QList>

#include "lib_parser/lib.h"

class GPSTUDIO_GUI_EXPORT LibItemModel : public QAbstractItemModel
{
    Q_OBJECT
public:
    explicit LibItemModel(QObject *parent = 0);

    enum Column {
        Name,
        Description,
        ColumnCount
    };

    int columnCount(const QModelIndex &parent) const;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const;
    QVariant data(const QModelIndex &index, int role) const;
    QModelIndex index(int row, int column, const QModelIndex &parent) const;
    QModelIndex parent(const QModelIndex &child) const;
    int rowCount(const QModelIndex &parent) const;
    Qt::ItemFlags flags(const QModelIndex &index) const;

    void setLib(const Lib *lib);
    QList<ProcessLib> processList() const;

signals:

public slots:

private:
    QList<ProcessLib> _processList;

};

#endif // LIBITEMMODEL_H
