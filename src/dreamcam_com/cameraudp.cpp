#include "cameraudp.h"

CameraUDP::CameraUDP()
{
}

bool CameraUDP::connect(const CameraInfo &info)
{
    return true;
}

bool CameraUDP::disconnect()
{
    return true;
}

bool CameraUDP::resetDevice()
{
    return true;
}

bool CameraUDP::isConnected() const
{
    return true;
}

QByteArray CameraUDP::read(const unsigned maxSize, const int timeOut, bool *state)
{
    return QByteArray();
}

bool CameraUDP::write(const QByteArray &array, const int timeOut)
{
    Q_UNUSED(array);
    return true;
}

QVector<CameraInfo> CameraUDP::avaibleCams()
{
    QVector<CameraInfo> avaibleCams;
    return avaibleCams;
}

int CameraUDP::status() const
{
    return 0;
}
