#include "flowconnection.h"

FlowConnection::FlowConnection()
{
}

int FlowConnection::flowId() const
{
    return _flowId;
}

void FlowConnection::setFlowId(int flowId)
{
    _flowId = flowId;
}

DataWrapper *FlowConnection::wrapper() const
{
    return _wrapper;
}

void FlowConnection::setWrapper(DataWrapper *wrapper)
{
    _wrapper = wrapper;
}

QWidget *FlowConnection::flowViewer() const
{
    return _flowViewer;
}

void FlowConnection::setFlowViewer(QWidget *flowViewer)
{
    _flowViewer = flowViewer;
}
