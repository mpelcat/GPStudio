#include "camerainfo.h"

CameraInfo::CameraInfo(const QString &name, const QString &driverType, const QString &addr)
{
    setName(name);;
    setDriverType(driverType);
    setAddr(addr);
}

QString CameraInfo::name() const
{
    return _name;
}

void CameraInfo::setName(const QString &name)
{
    _name = name;
}

QString CameraInfo::driverType() const
{
    return _driverType;
}

void CameraInfo::setDriverType(const QString &driverType)
{
    _driverType = driverType;
}

QString CameraInfo::addr() const
{
    return _addr;
}

void CameraInfo::setAddr(const QString &addr)
{
    _addr = addr;
}

bool CameraInfo::isValid() const
{
    if(_name.isEmpty() || _driverType.isEmpty()) return false; else return true;
}

QDebug operator<<(QDebug d, const CameraInfo &cameraInfo)
{
    QString outDebug=QString("%1 connected at %2 by %3").arg(cameraInfo._name)
                                                        .arg(cameraInfo._addr)
                                                        .arg(cameraInfo._driverType);
    d << outDebug;
    return d;
}
