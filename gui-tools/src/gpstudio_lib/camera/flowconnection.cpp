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

ModelFlow *FlowConnection::flow() const
{
    return _flow;
}

void FlowConnection::setFlow(ModelFlow *flow)
{
    _flow = flow;
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
