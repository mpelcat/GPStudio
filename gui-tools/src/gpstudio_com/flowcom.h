#ifndef FLOW_COM_H
#define FLOW_COM_H

#include <QQueue>
#include <QMetaType>
#include <QMutex>

#include "gpstudio_com_common.h"
#include "flowdata.h"

class GPSTUDIO_COM_EXPORT FlowCom
{
public:
    FlowCom(const int idFlow=0);
    FlowCom(const FlowCom &other);

    unsigned char idFlow() const;
    void setIdFlow(const unsigned char idFlow);

    unsigned int numPacket() const;

    // Flow OUT
    bool readyToSend() const;
    QByteArray dataToSend(const int size);

    void send(const FlowPackage &flowData);

    void send(const QImage &image);
    void send(const QByteArray &data);
    //void send(const Mat);
    //void send(const stdVector);

    // Flow IN
    void appendData(const QByteArray &data);

    FlowPackage getData();
    void validate();
    unsigned getSize() const;

private:
    unsigned char _idFlow;
    unsigned int _numPacket;

    QQueue<FlowPackage> _flowDataToSend;     // flowData to send

    FlowPackage _current;              // flowData currently received
    FlowPackage _lastFlowData;              // flowData currently received
    QMutex _mutexDataRead;
};

Q_DECLARE_METATYPE(FlowCom)

#endif // FLOW_COM_H
