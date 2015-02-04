#ifndef CAMERAIO_H
#define CAMERAIO_H

#include <QByteArray>
#include <QVector>

#include "dreamcam_com.h"
#include "camerainfo.h"

class DREAMCAMCOM_EXPORT CameraIO
{
public:
    CameraIO();
    virtual ~CameraIO();

    virtual bool connect(const CameraInfo &info=CameraInfo()) =0;
    virtual bool disconnect() =0;
    virtual bool resetDevice() =0;
    virtual bool isConnected() const =0;

    virtual QByteArray read(const unsigned maxSize=512, const int timeOut=1000, bool *state=NULL) =0;
    virtual bool write(const QByteArray &array, const int timeOut=1000) =0;

    virtual int sizePacket() const =0;

    virtual int status() const =0;
};

#endif // CAMERAIO_H
