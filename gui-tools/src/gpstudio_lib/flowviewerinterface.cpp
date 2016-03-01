#include "flowviewerinterface.h"

#include <QDebug>

FlowViewerInterface::FlowViewerInterface(const FlowConnection &flowConnection)
{
    _flowConnections.append(flowConnection);
    qDebug()<<"construct interface";
}

FlowViewerInterface::FlowViewerInterface(const QList<FlowConnection> &flowConnections)
{
    _flowConnections.append(flowConnections);
    qDebug()<<"construct interface";
}

FlowViewerInterface::~FlowViewerInterface()
{
    qDebug()<<"destruct interface";
}

const QList<FlowConnection> &FlowViewerInterface::flowConnections() const
{
    return _flowConnections;
}

void FlowViewerInterface::updateFlowConnection()
{
    foreach (const FlowConnection &flowConnection, _flowConnections)
    {
        //flowConnection.flow()->properties();
    }
}

