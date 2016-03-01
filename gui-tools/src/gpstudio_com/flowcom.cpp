#include "flowcom.h"

#include <QDebug>
#include <QMutexLocker>

FlowCom::FlowCom(const int idFlow)
    : _idFlow(idFlow)
{
}

FlowCom::FlowCom(const FlowCom &other)
    : _idFlow(other._idFlow), _numPacket(other._numPacket), _flowDataToSend(other._flowDataToSend)
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
    if(_flowDataToSend.size()!=0) return true;
    else return false;
}

QByteArray FlowCom::dataToSend(const int size)
{
    QByteArray dataToSend;

    if(_flowDataToSend.head().empty()) _flowDataToSend.dequeue();
    if(_flowDataToSend.empty()) return QByteArray();
    if(size<=4) return QByteArray();

    QByteArray data = _flowDataToSend.head().getPart(size-4);

    dataToSend.append(_idFlow);
    if(_flowDataToSend.head().empty())
    {
        _flowDataToSend.dequeue();
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

void FlowCom::send(const FlowPackage &flowData)
{
    _flowDataToSend.append(flowData);
}

void FlowCom::send(const QImage &image)
{
    send(FlowPackage(image));
}

void FlowCom::send(const QByteArray &data)
{
    send(FlowPackage(data));
}

void FlowCom::appendData(const QByteArray &data)
{
    _current.appendData(data.mid(4));
}

FlowPackage FlowCom::getData()
{
    QMutexLocker locker(&_mutexDataRead);
    return _lastFlowData;
}

void FlowCom::validate()
{
    _mutexDataRead.lock();
    _lastFlowData = _current;
    _current.clear();
    _mutexDataRead.unlock();
}

unsigned FlowCom::getSize() const
{
    return _current.data().size();
}
