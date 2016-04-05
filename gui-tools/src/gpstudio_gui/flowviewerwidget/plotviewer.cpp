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

#include "plotviewer.h"

#include <QDebug>
#include <QVBoxLayout>

#include "flowviewerinterface.h"

PlotViewer::PlotViewer(FlowViewerInterface *flowViewerInterface)
    : AbstractViewer(flowViewerInterface)
{
    setupWidgets();
    connect((QObject*)_flowViewerInterface, SIGNAL(dataReceived(int)), this, SLOT(showFlowConnection(int)));
}

PlotViewer::~PlotViewer()
{
}

void PlotViewer::showFlowConnection(int flowId)
{
    const FlowPackage flowPackage = _flowViewerInterface->flowConnections()[flowId]->lastData();

    QByteArray data = flowPackage.data();

    short ax = ((short)((char)data[0])<<8) + data[1];
    float axf = ax / 16384.0;
    short ay = ((short)((char)data[2])<<8) + data[3];
    float ayf = ay / 16384.0;
    short az = ((short)((char)data[4])<<8) + data[5];
    float azf = az / 16384.0;

    _widget->graph(0)->addData(QCPData(QDateTime::currentMSecsSinceEpoch(), axf));
    _widget->graph(1)->addData(QCPData(QDateTime::currentMSecsSinceEpoch(), ayf));
    _widget->graph(2)->addData(QCPData(QDateTime::currentMSecsSinceEpoch(), azf));
    _widget->graph(0)->rescaleAxes();
    _widget->graph(1)->rescaleAxes();
    _widget->graph(2)->rescaleAxes();
    _widget->replot();
}

void PlotViewer::setupWidgets()
{
    QLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);

    _widget = new QCustomPlot();
    _widget->addGraph();
    _widget->graph(0)->setName("x");
    _widget->graph(0)->setPen(QColor(Qt::red));
    _widget->addGraph();
    _widget->graph(1)->setName("y");
    _widget->graph(1)->setPen(QColor(Qt::blue));
    _widget->addGraph();
    _widget->graph(2)->setName("z");
    _widget->graph(2)->setPen(QColor(Qt::black));
    _widget->yAxis->setRange(-2,2);

    layout->addWidget(_widget);

    setLayout(layout);
}
