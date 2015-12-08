#include "flowconnection.h"

FlowConnection::FlowConnection()
{
    _fps=0;
}

int FlowConnection::flowId() const
{
    return _flowId;
}

void FlowConnection::setFlowId(int flowId)
{
    _flowId = flowId;
}

Flow *FlowConnection::flow() const
{
    return _flow;
}

void FlowConnection::setFlow(Flow *flow)
{
    _flow = flow;
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

void FlowConnection::recImg()
{
    if(_prevImgReceive.isValid())
    {
        _fps = 1.0 / (QDateTime::currentDateTime().toMSecsSinceEpoch() - _prevImgReceive.toMSecsSinceEpoch()) * 1000.0;
    }
    _prevImgReceive = QDateTime::currentDateTime();
}

float FlowConnection::fps() const
{
    return _fps;
}
