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

#include "camexplorerwidget.h"

#include "camera/camera.h"

#include <QDebug>
#include <QFormLayout>
#include <QLabel>
#include <QModelIndexList>
#include <QSplitter>

#include <propertywidgets/propertywidget.h>

CamExplorerWidget::CamExplorerWidget(QWidget *parent)
    : QWidget(parent)
{
    setCamera(NULL);
    setModeView(WidgetsMode);
}

CamExplorerWidget::CamExplorerWidget(Camera *camera, QWidget *parent)
    : QWidget(parent)
{
    setCamera(camera);
    setModeView(WidgetsMode);
}

CamExplorerWidget::CamExplorerWidget(Camera *camera, CamExplorerWidget::Mode modeView, QWidget *parent)
    : QWidget(parent)
{
    setCamera(camera);
    setModeView(modeView);
}

void CamExplorerWidget::setupWidgets()
{
    if(layout())
        layout()->deleteLater();

    QLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);

    QSplitter *splitter = new QSplitter();
    splitter->setOrientation(Qt::Vertical);
    layout->addWidget(splitter);

    _camItemModel = new CameraItemModelNoSorted();
    _camTreeView = new QTreeView();
    _camTreeView->setModel(_camItemModel);
    _camTreeView->setSortingEnabled(true);
    splitter->addWidget(_camTreeView);

    connect(_camTreeView, SIGNAL(clicked(QModelIndex)), this, SLOT(updateRootProperty(QModelIndex)));
    connect(_camTreeView, SIGNAL(activated(QModelIndex)), this, SLOT(updateRootProperty(QModelIndex)));

    switch (_modeView)
    {
    case CamExplorerWidget::TreeViewMode:
        _propertyItemModel = new PropertyItemModelNoSorted();
        _propertyTreeView = new QTreeView();
        _propertyTreeView->setModel(_propertyItemModel);
        _propertyTreeView->setSortingEnabled(true);
        splitter->addWidget(_propertyTreeView);
        break;
    case CamExplorerWidget::WidgetsMode:
    {
        _propertyWidget = new QScrollArea();
        _propertyWidget->setWidgetResizable(true);
        splitter->addWidget(_propertyWidget);
        break;
    }
    default:
        break;
    }

    setLayout(layout);
}

void CamExplorerWidget::setRootProperty(const Property *property)
{
    switch (_modeView)
    {
    case CamExplorerWidget::WidgetsMode:
        {
            QWidget *widget = new QWidget();
            widget->setSizePolicy(QSizePolicy::Maximum, QSizePolicy::Maximum);

            QFormLayout *layoutPanel = new QFormLayout();
            layoutPanel->setFieldGrowthPolicy(QFormLayout::AllNonFixedFieldsGrow);
            layoutPanel->setSpacing(6);

            if(property)
            {
                foreach (Property *subProperty, property->subPropertiesMap())
                {
                    PropertyWidget *propertyWidget = PropertyWidget::getWidgetFromProperty(subProperty);
                    if(propertyWidget)
                    {
                        if(propertyWidget->type()==PropertyWidget::Field)
                        {
                            layoutPanel->addRow(subProperty->caption(), propertyWidget);
                        }
                        else
                        {
                            layoutPanel->setWidget(layoutPanel->count(), QFormLayout::SpanningRole, propertyWidget);
                        }
                    }
                }
            }

            // TODO get internal size
            widget->setMinimumWidth(_propertyWidget->viewport()->width()-30);
            widget->setLayout(layoutPanel);

            _propertyWidget->setWidget(widget);

            break;
        }
    case CamExplorerWidget::TreeViewMode:
        _propertyItemModel->setRootProperty(property);
        break;
    }
}

CamExplorerWidget::Mode CamExplorerWidget::modeView() const
{
    return _modeView;
}

void CamExplorerWidget::setModeView(const Mode &modeView)
{
    _modeView = modeView;
    setupWidgets();
}

Camera *CamExplorerWidget::camera() const
{
    return _camera;
}

void CamExplorerWidget::setCamera(Camera *camera)
{
    _camera = camera;
    if(_camera)
    {
        _camItemModel->clearAll();
        _camItemModel->addCamera(camera);
        _camTreeView->expandToDepth(0);
        _camTreeView->resizeColumnToContents(0);

        //setRootProperty(NULL);
    }
}

void CamExplorerWidget::updateRootProperty(QModelIndex index)
{
    if(!index.isValid() || index.model()!=_camItemModel)
    {
        setRootProperty(NULL);
        return;
    }

    QModelIndex localMapToSource = index;/*_camItemModel->mapToSource(index);
    if(!localMapToSource.isValid())
    {
        setRootProperty(NULL);
        return;
    }*/

    CameraItem *item = static_cast<CameraItem*>(localMapToSource.internalPointer());
    if(!item)
    {
        setRootProperty(NULL);
        return;
    }

    switch (item->type())
    {
    case CameraItem::CameraType:
        setRootProperty(&item->camera()->rootProperty());
        break;
    case CameraItem::BlockType:
        setRootProperty(item->block()->assocProperty());
        break;
    case CameraItem::FlowType:
        setRootProperty(item->flow()->assocProperty());
        break;
    default:
        setRootProperty(NULL);
        break;
    }
}

void CamExplorerWidget::selectBlock(const Block *block)
{
    QModelIndexList items = _camTreeView->model()->match(_camTreeView->model()->index(0, 0), Qt::DisplayRole, QVariant(block->name()), -1, Qt::MatchRecursive);
    if(items.count()>0)
    {
        _camTreeView->selectionModel()->clearSelection();
        _camTreeView->selectionModel()->select(items.at(0), QItemSelectionModel::Select | QItemSelectionModel::Rows);
        updateRootProperty(items.at(0));
    }
}
