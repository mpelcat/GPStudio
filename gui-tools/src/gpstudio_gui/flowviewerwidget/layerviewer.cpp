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

#include "layerviewer.h"

#include <QDebug>
#include <QVBoxLayout>

#include "flowviewerinterface.h"

LayerViewer::LayerViewer(FlowViewerInterface *flowViewerInterface)
    : AbstractViewer(flowViewerInterface)
{
    setupWidgets();
    //showFlowConnection(0);
    connect((QObject*)_flowViewerInterface, SIGNAL(dataReceived(int)), this, SLOT(showFlowConnection(int)));
}

LayerViewer::~LayerViewer()
{
}

void LayerViewer::showFlowConnection(int flowId)
{
    if(flowId>=_flowViewerInterface->flowConnections().size())
        return;

    const FlowPackage flowPackage = _flowViewerInterface->flowConnections()[flowId]->lastData();
    Property *flowProp = _flowViewerInterface->flowConnections()[flowId]->flow()->assocProperty();

    int width = flowProp->property("width").toInt();
    int height = flowProp->property("height").toInt();

    QImage *image = flowPackage.toImage(width, height, 8);
    _widget->showImage(*image);
    delete image;
}

void LayerViewer::setupWidgets()
{
    QLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);

    _widget = new LayerWidget();

    layout->addWidget(_widget);

    setLayout(layout);
}
