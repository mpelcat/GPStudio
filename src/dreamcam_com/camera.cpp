#include "camera.h"

// camera io driver
#include "camerausb.h"

#include <QDebug>

Camera::Camera(const CameraInfo &cameraInfo)
{
    _cameraIO = NULL;
    qDebug()<<cameraInfo.driverType();

    //if(cameraInfo.driverType().contains("USB", Qt::CaseInsensitive))
    {
        _cameraIO = new CameraUSB();
    }

    if(_cameraIO) _cameraIO->connect(cameraInfo);

    // TODO pass this part dynamic
    _outputFlow.append(new Flow(15));   // set param
    _paramFlow = _outputFlow[0];

    _outputFlow.append(new Flow(1));

    _inputFlow.append(new Flow(0x80));
    _inputFlow.append(new Flow(0x81));

    _start=true;
    start(QThread::HighestPriority);
}

Camera::~Camera()
{
    terminate();
    delete _cameraIO;
}

bool Camera::isConnected() const
{
    if(_cameraIO) return _cameraIO->isConnected();
    else return false;
}

void Camera::stop()
{
    _start=false;
    this->wait();
}

QVector<CameraInfo> Camera::avaibleCams()
{
    QVector<CameraInfo> avaibleCams;

    avaibleCams += CameraUSB::avaibleCams();

    return avaibleCams;
}

void Camera::run()
{
    while(_start)
    {
        const QByteArray &received = _cameraIO->read(10);
        int prev_numpacket;
        if(received.size()>0)
        {
            emit packetArrived(received);

            unsigned char idFlow = received[0];
            unsigned char flagFlow = received[1];
            unsigned short numpacket = ((unsigned short)((unsigned char)received[2])*256)+(unsigned char)received[3];

            for(int i=0; i<_inputFlow.size(); i++)
            {
                if(_inputFlow[i]->idFlow()==idFlow)
                {
                    if(prev_numpacket+1 != numpacket)
                    {
                        int miss_packet = numpacket-prev_numpacket-1;
                        qDebug()<<"miss"<<miss_packet<<numpacket;
                        for(int j=0; j<miss_packet; j++) _inputFlow[i]->appendData(QByteArray(512,0));
                    }
                    _inputFlow[i]->appendData(received);
                    prev_numpacket = numpacket;

                   //if(_inputFlow[i]->getSize()>=320*240*2)
                    if(flagFlow==0xBA)
                    {
                        prev_numpacket=-1;
                        _inputFlow[i]->validate();
                        emit flowReadyToRead(i);
                    }
                }
            }
            if(idFlow == 0xFD)
            {
                //emit flowReadyToRead(received);
            }
        }
        for(int i=0; i<_outputFlow.size(); i++)
        {
            if(_outputFlow[i]->readyToSend())
            {
                const QByteArray data = _outputFlow[i]->dataToSend(_cameraIO->sizePacket());
                _cameraIO->write(data);
            }
        }

        //QThread::sleep(100);
    }
}

CameraIO *Camera::cameraIO() const
{
    return _cameraIO;
}

void Camera::writeParam(const unsigned int addr, const unsigned int value)
{
    QByteArray byte;

    // addr
    byte.append((char)(addr >> 24));
    byte.append((char)(addr >> 16));
    byte.append((char)(addr >> 8));
    byte.append((char)addr);
    // data
    byte.append((char)(value >> 24));
    byte.append((char)(value >> 16));
    byte.append((char)(value >> 8));
    byte.append((char)value);

    _paramFlow->send(byte);
    //_cameraIO->write(byte,5);
    qDebug() << "param_trame: "<< byte.toHex();
}

void Camera::writeParam(const unsigned short addr, const char *data, const unsigned size)
{
    Q_UNUSED(addr);
    Q_UNUSED(data);
    Q_UNUSED(size);
}

void Camera::askStatus()
{
    QByteArray byte;
    byte.append((char)0x00);
    byte.append((char)0xFD);
    _cameraIO->write(byte);
}

const QList<Flow*> &Camera::outputFlow() const
{
    return _outputFlow;
}

QList<Flow*> &Camera::outputFlow()
{
    return _outputFlow;
}

const QList<Flow*> &Camera::inputFlow() const
{
    return _inputFlow;
}

QList<Flow*> &Camera::inputFlow()
{
    return _inputFlow;
}
