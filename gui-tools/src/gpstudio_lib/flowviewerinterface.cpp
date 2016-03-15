#include "flowviewerinterface.h"

#include <QDebug>

FlowViewerInterface::FlowViewerInterface(FlowConnection *flowConnection)
{
    addFlowConnection(flowConnection);
}

FlowViewerInterface::FlowViewerInterface(const QList<FlowConnection *> &flowConnections)
{
    foreach (FlowConnection *flowConnection, flowConnections)
    {
        addFlowConnection(flowConnection);
    }
}

FlowViewerInterface::~FlowViewerInterface()
{
}

const QList<FlowConnection *> &FlowViewerInterface::flowConnections() const
{
    return _flowConnections;
}

void FlowViewerInterface::addFlowConnection(FlowConnection *flowConnection)
{
    _flowConnections.append(flowConnection);
    // flow connect
}

void FlowViewerInterface::removeFlowConnection(FlowConnection *flowConnection)
{
    _flowConnections.removeOne(flowConnection);
}

void FlowViewerInterface::moveFlowConnection(FlowConnection *flowConnection, int index)
{
    int find;
    if((find=_flowConnections.indexOf(flowConnection))>=0)
    {
        if(index>=_flowConnections.count())
            return;
        _flowConnections.move(find, index);
    }
}

void FlowViewerInterface::changeDataType()
{

}
