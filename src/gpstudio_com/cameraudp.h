#ifndef CAMERAUDP_H
#define CAMERAUDP_H

#include "gpstudio_com_common.h"
#include "cameraio.h"

class GPSTUDIO_COM_EXPORT CameraUDP : public CameraIO
{
public:
    CameraUDP();

    bool connect(const CameraInfo &info=CameraInfo());
    bool disconnect();
    bool resetDevice();
    bool isConnected() const;

    QByteArray read(const unsigned maxSize=512, const int timeOut=1000, bool *state=NULL);
    bool write(const QByteArray &array, const int timeOut=1000);

    static QVector<CameraInfo> avaibleCams();

    int sizePacket() const {return 1024;}

    int status() const;
};

#endif // CAMERAUDP_H
