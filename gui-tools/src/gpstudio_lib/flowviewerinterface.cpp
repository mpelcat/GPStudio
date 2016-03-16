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

    // flow connect to reception
    connect(flowConnection, SIGNAL(flowReceived(FlowPackage)), this, SLOT(processData(FlowPackage)));

    // connect to flow properties
    Property *dataTypeProperty = flowConnection->flow()->assocProperty()->path("datatype");
    if(dataTypeProperty)
        connect(dataTypeProperty, SIGNAL(valueChanged(QVariant)), this, SLOT(changeDataType()));

    foreach (Property *property, flowConnection->flow()->assocProperty()->subProperties())
    {
        //qDebug()<<property->name();
    }
    changeDataType();
}

void FlowViewerInterface::removeFlowConnection(FlowConnection *flowConnection)
{
    _flowConnections.removeOne(flowConnection);

    // disconnect all from the connection
    disconnect(flowConnection, 0, this, 0);
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
    if(_flowConnections.empty())
        return;

    Property *dataTypeProperty = _flowConnections[0]->flow()->assocProperty()->path("datatype");
    if(!dataTypeProperty)
        return;

    _dataType = dataTypeProperty->value().toString();
    emit dataTypeChanged();

    qDebug()<<Q_FUNC_INFO<<dataTypeProperty->value();
}

void FlowViewerInterface::processData(FlowPackage data)
{
    FlowConnection *connection = FlowViewerInterface::objectToFlowConnection(QObject::sender());
    if(!connection)
        return;

    int index = _flowConnections.indexOf(connection);
    if(index==-1)
        return;

    emit dataReceived(index);

    qDebug()<<Q_FUNC_INFO<<data.data().size()<<connection->flow()->name();
}

FlowConnection *FlowViewerInterface::objectToFlowConnection(QObject *object)
{
    return qobject_cast<FlowConnection *>(object);
}

QString FlowViewerInterface::dataType() const
{
    return _dataType;
}
