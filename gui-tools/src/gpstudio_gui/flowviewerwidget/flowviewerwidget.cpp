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

#include "flowviewerwidget.h"

#include <QBoxLayout>
#include <QStatusBar>

#include <QDebug>

#include "layerviewer.h"

FlowViewerWidget::FlowViewerWidget(const QSharedPointer<FlowViewerInterface> &flowViewerInterface) :
    QWidget(NULL),
    _viewer(NULL)
{
    setupWidgets(NULL);
    setFlowViewerInterface(flowViewerInterface);
    changeType();
}

FlowViewerWidget::FlowViewerWidget(FlowViewerInterface *flowViewerInterface) :
    QWidget(NULL),
    _viewer(NULL)
{
    setupWidgets(NULL);
    setFlowViewerInterface(QSharedPointer<FlowViewerInterface>(flowViewerInterface));
    changeType();
}

FlowViewerWidget::FlowViewerWidget(const FlowViewerWidget &other) :
    QWidget(NULL),
    _viewer(other._viewer)
{
    setupWidgets(NULL);
    setFlowViewerInterface(other._flowViewerInterface);
    changeType();
}

FlowViewerWidget::~FlowViewerWidget()
{
}

FlowViewerWidget &FlowViewerWidget::operator=(const FlowViewerWidget &other)
{
    setFlowViewerInterface(other._flowViewerInterface);
    return *this;
}

void FlowViewerWidget::changeType()
{
    FlowViewerInterface::FlowDataType dataType = _flowViewerInterface.data()->dataType();

    if(dataType==FlowViewerInterface::ImageFlowType)
    {
        setupWidgets(new LayerViewer(_flowViewerInterface.data()));
    }
    else
        setupWidgets(NULL);
}

void FlowViewerWidget::dataReceive(int flowId)
{
    if(_statusLabel)
    {
        _statusLabel->setText(_flowViewerInterface.data()->statusText());

        // 22 fps image 320*240px
    }
}

void FlowViewerWidget::setupWidgets(AbstractViewer *viewer)
{
    if(layout())
    {
        QLayoutItem *child;
        while ((child = layout()->takeAt(0)) != 0)
        {
            if(child->widget())
            {
                child->widget()->hide();
                child->widget()->deleteLater();
            }
            if(child->layout())
            {
                QLayoutItem *child2;
                while ((child2 = child->layout()->takeAt(0)) != 0)
                {
                    if(child2->widget())
                    {
                        child2->widget()->hide();
                        child2->widget()->deleteLater();
                    }
                    delete child2;
                }
            }
            delete child;
        }
        delete layout();
    }
    QLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);

    if(viewer==NULL)
        viewer = new AbstractViewer(new FlowViewerInterface);

    layout->addWidget(viewer);
    _viewer = viewer;

    // status
    _statusLayout = new QHBoxLayout();
    _statusLayout->setContentsMargins(0,0,0,0);

    _statusLabel = new QLabel("");
    _statusLayout->addWidget(_statusLabel);

    _typeComboBox = new QComboBox();
    _statusLayout->addWidget(_typeComboBox);
    _typeComboBox->addItem("image");
    _typeComboBox->addItem("hexa");

    layout->addItem(_statusLayout);

    setLayout(layout);
}

void FlowViewerWidget::setFlowViewerInterface(const QSharedPointer<FlowViewerInterface> &flowViewerInterface)
{
    _flowViewerInterface = flowViewerInterface;
    connect(_flowViewerInterface.data(), SIGNAL(dataTypeChanged()), this, SLOT(changeType()));
    connect(_flowViewerInterface.data(), SIGNAL(dataReceived(int)), this, SLOT(dataReceive(int)));
}

//QMutexLocker _viewerLock;
