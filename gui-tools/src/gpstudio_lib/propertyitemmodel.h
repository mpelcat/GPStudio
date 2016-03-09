#ifndef PROPERTYITEMMODEL_H
#define PROPERTYITEMMODEL_H

#include "gpstudio_lib_common.h"

#include <QAbstractItemModel>
#include <QSortFilterProxyModel>

class Property;

class GPSTUDIO_LIB_EXPORT PropertyItemModelNoSorted : public QAbstractItemModel
{
    Q_OBJECT

public:
    PropertyItemModelNoSorted(QObject *parent = 0);
    explicit PropertyItemModelNoSorted(Property *property, QObject *parent = 0);

    enum Column {
        Name,
        Value,
        ColumnCount
    };

    const Property *rootProperty() const;
    void setRootProperty(const Property *rootProperty);

    // QAbstractItemModel interface
public:
    // Header:
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const;

    // Basic functionality:
    QModelIndex index(int row, int column, const QModelIndex &parent = QModelIndex()) const;
    QModelIndex parent(const QModelIndex &child) const;

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    int columnCount(const QModelIndex &parent = QModelIndex()) const;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;

    // Editable:
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole);

    Qt::ItemFlags flags(const QModelIndex& index) const;

private:
    const Property *_rootProperty;
};

class GPSTUDIO_LIB_EXPORT PropertyItemModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    PropertyItemModel(QObject *parent = 0);
    explicit PropertyItemModel(Property *property, QObject *parent = 0);

    const Property *rootProperty() const;
    void setRootProperty(const Property *rootProperty);

private:
    PropertyItemModelNoSorted *_modelProperty;
};

#endif // PROPERTYITEMMODEL_H
