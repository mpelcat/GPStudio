#include "flowcom.h"

#include <QDebug>

FlowCom::FlowCom(const int idFlow)
    : _idFlow(idFlow)
{
}

FlowCom::FlowCom(const FlowCom &other)
    : _idFlow(other._idFlow), _numPacket(other._numPacket), _flowData(other._flowData)
{
}

unsigned char FlowCom::idFlow() const
{
    return _idFlow;
}

void FlowCom::setIdFlow(const unsigned char idFlow)
{
    _idFlow = idFlow;
}

unsigned int FlowCom::numPacket() const
{
    return _numPacket;
}

bool FlowCom::readyToSend() const
{
    if(_flowData.size()!=0) return true;
    else return false;
}

QByteArray FlowCom::dataToSend(const int size)
{
    QByteArray dataToSend;

    if(_flowData.head().empty()) _flowData.dequeue();
    if(_flowData.empty()) return QByteArray();
    if(size<=4) return QByteArray();

    QByteArray data = _flowData.head().getPart(size-4);

    dataToSend.append(_idFlow);
    if(_flowData.head().empty())
    {
        _flowData.dequeue();
        dataToSend.append(0xBA);
    }
    else dataToSend.append(0xAA);

    dataToSend.append((unsigned char)_numPacket);
    dataToSend.append((unsigned char)_numPacket/256);
    dataToSend.append(data);

       // rajouter des 0 en fin de packet
   // for(int i=dataToSend.size(); i<size; i++) dataToSend.append((char)0);

    return dataToSend;
}

void FlowCom::send(const FlowData &flowData)
{
    _flowData.append(flowData);
}

void FlowCom::send(const QImage &image)
{
    send(FlowData(image));
}

void FlowCom::send(const QByteArray &data)
{
    send(FlowData(data));
}

void FlowCom::appendData(const QByteArray &data)
{
    /*if(_flowData.empty())
    {
        _flowData.append(FlowData(data.mid(4)));
    }
    else
    {
        _flowData.head().appendData(data.mid(4));
    }*/
    _current.appendData(data.mid(4));
}

FlowData FlowCom::getData()
{
    if(_flowData.empty()) return FlowData();

    return _flowData.dequeue();
}

void FlowCom::validate()
{
    _flowData.append(_current);
    _current.clear();
}

unsigned FlowCom::getSize() const
{
    /*if(_flowData.empty()) return 0;
    return _flowData.head().data().size();*/
    return _current.data().size();
}

void FlowCom::clear()
{
    _flowData.clear();
}
