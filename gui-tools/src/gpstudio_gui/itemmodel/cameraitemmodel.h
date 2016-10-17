/****************************************************************************
** Copyright (C) 2016 Dream IP
** 
** This file is part of GPStudio.
**
** GPStudio is a free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program.  If not, see <http://www.gnu.org/licenses/>.
**
****************************************************************************/

#ifndef CAMERAITEMMODEL_H
#define CAMERAITEMMODEL_H

#include "gpstudio_gui_common.h"

#include "cameraitem.h"

#include <QAbstractItemModel>
#include <QSortFilterProxyModel>

class Camera;
class ModelNode;

class GPSTUDIO_GUI_EXPORT CameraItemModelNoSorted : public QAbstractItemModel
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
    void addBlock(const Block *block);
    void addNode(const ModelNode *node);
    void clearAll();

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

class GPSTUDIO_GUI_EXPORT CameraItemModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit CameraItemModel(QObject *parent = 0);
    CameraItemModel(Camera *camera, QObject *parent = 0);

    void addCamera(const Camera *camera);
    void clearAll();

private:
    CameraItemModelNoSorted *_modelCam;
};

#endif // CAMERAITEMMODEL_H
