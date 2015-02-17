#ifndef FLOW_H
#define FLOW_H

#include <QQueue>
#include <QMetaType>

#include "gpstudio_com_common.h"
#include "flowdata.h"

class GPSTUDIO_COM_EXPORT Flow
{
public:
    Flow(const int idFlow=0);
    Flow(const Flow &other);

    unsigned char idFlow() const;
    void setIdFlow(const unsigned char idFlow);
    unsigned int numPacket() const;

    bool readyToSend() const;
    QByteArray dataToSend(const int size);

    void send(const FlowData &flowData);

    void send(const QImage &image);
    void send(const QByteArray &data);
    //void send(const Mat);
    //void send(const stdVector);

    void appendData(QByteArray data);

    FlowData getData();
    void validate();
    unsigned getSize() const;

    void clear();

private:
    unsigned char _idFlow;
    unsigned int _numPacket;
    QQueue<FlowData> _flowData;
    FlowData _current;
};

Q_DECLARE_METATYPE(Flow)

#endif // FLOW_H
