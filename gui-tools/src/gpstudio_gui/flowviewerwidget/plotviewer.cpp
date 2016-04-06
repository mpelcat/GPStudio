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

#include "scriptengine.h"

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

    QScriptValue function = ScriptEngine::getEngine().engine()->evaluate("(function(x){ return x / 16384.0;})");

    for(int i=0; i<data.size(); i+=2)
    {
        if(i>6) break;
        short dataItem = ((short)((char)data[i])<<8) + data[i+1];
        QScriptValueList args;
        args << dataItem;

        if(_widget->graphCount()<i+1)
        {
            _widget->addGraph();
            _widget->graph(i/2)->setName(QString("plot%1").arg(i));
            _widget->graph(i/2)->setPen(QColor::fromHsv(i*10,255,255));
            _widget->graph(i/2)->setAdaptiveSampling(true);
        }

        float value = function.call(QScriptValue(), args).toNumber();
        _widget->graph(i/2)->addData(QCPData(QDateTime::currentMSecsSinceEpoch(), value));
    }

    if(_startDate==0)
    {
        _startDate = QDateTime::currentMSecsSinceEpoch();
    }
    _widget->xAxis->setRange(_startDate, QDateTime::currentMSecsSinceEpoch());

    _widget->replot();
}

void PlotViewer::setupWidgets()
{
    QLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);

    _widget = new QCustomPlot();
    _widget->yAxis->setRange(-2,2);
    _widget->legend->setVisible(true);
    _widget->xAxis->setTickLabelType(QCPAxis::ltDateTime);
    _widget->xAxis->setDateTimeFormat("HH:mm:ss");

    layout->addWidget(_widget);

    setLayout(layout);
}
