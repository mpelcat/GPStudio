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

FlowViewerWidget::FlowViewerWidget(const QSharedPointer<FlowViewerInterface> &flowViewerInterface) :
    QWidget(NULL),
    _flowViewerInterface(flowViewerInterface),
    _viewer(NULL)
{
    setupWidgets();
    connect(_flowViewerInterface.data(), SIGNAL(dataTypeChanged()), this, SLOT(changeType()));
    changeType();
}

FlowViewerWidget::FlowViewerWidget(FlowViewerInterface *flowViewerInterface) :
    QWidget(NULL),
    _flowViewerInterface(flowViewerInterface),
    _viewer(NULL)
{
    setupWidgets();
    connect(_flowViewerInterface.data(), SIGNAL(dataTypeChanged()), this, SLOT(changeType()));
    changeType();
}

FlowViewerWidget::FlowViewerWidget(const FlowViewerWidget &other) :
    QWidget(NULL),
    _flowViewerInterface(other._flowViewerInterface),
    _viewer(other._viewer)
{
    setupWidgets();
    connect(_flowViewerInterface.data(), SIGNAL(dataTypeChanged()), this, SLOT(changeType()));
    changeType();
}

FlowViewerWidget::~FlowViewerWidget()
{
}

FlowViewerWidget &FlowViewerWidget::operator=(const FlowViewerWidget &other)
{
    _flowViewerInterface = other._flowViewerInterface;
    return *this;
}

void FlowViewerWidget::changeType()
{
    _statusLabel->setText(_flowViewerInterface.data()->dataType());
}

void FlowViewerWidget::setupWidgets()
{
    _layout = new QVBoxLayout();
    _layout->setContentsMargins(0,0,0,0);

    _viewer = new QWidget();
    _layout->addWidget(_viewer);

    // status
    _statusLayout = new QHBoxLayout();
    _statusLayout->setContentsMargins(0,0,0,0);

    _statusLabel = new QLabel("22 fps image 320*240px");
    _statusLayout->addWidget(_statusLabel);

    _typeComboBox = new QComboBox();
    _statusLayout->addWidget(_typeComboBox);
    _typeComboBox->addItem("image");
    _typeComboBox->addItem("hexa");

    _layout->addItem(_statusLayout);

    setLayout(_layout);
}

//QMutexLocker _viewerLock;
