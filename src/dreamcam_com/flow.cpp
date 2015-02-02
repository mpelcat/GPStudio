#include "flow.h"

#include <QDebug>

Flow::Flow(const int idFlow)
    : _idFlow(idFlow)
{
}

Flow::Flow(const Flow &other)
    : _idFlow(other._idFlow), _numPacket(other._numPacket), _flowData(other._flowData)
{
}

unsigned char Flow::idFlow() const
{
    return _idFlow;
}

void Flow::setIdFlow(const unsigned char idFlow)
{
    _idFlow = idFlow;
}

unsigned int Flow::numPacket() const
{
    return _numPacket;
}

bool Flow::readyToSend() const
{
    if(_flowData.size()!=0) return true;
    else return false;
}

QByteArray Flow::dataToSend(const int size)
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

void Flow::send(const FlowData &flowData)
{
    _flowData.append(flowData);
}

void Flow::send(const QImage &image)
{
    send(FlowData(image));
}

void Flow::send(const QByteArray &data)
{
    send(FlowData(data));
}

void Flow::appendData(QByteArray data)
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

FlowData Flow::getData()
{
    if(_flowData.empty()) return FlowData();

    return _flowData.dequeue();
}

void Flow::validate()
{
    _flowData.append(_current);
    _current.clear();
}

unsigned Flow::getSize() const
{
    /*if(_flowData.empty()) return 0;
    return _flowData.head().data().size();*/
    return _current.data().size();
}

void Flow::clear()
{
    _flowData.clear();
}
