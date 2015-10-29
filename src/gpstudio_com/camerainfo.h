#ifndef CAMERAINFO_H
#define CAMERAINFO_H

#include <QString>
#include <QDebug>

#include "gpstudio_com_common.h"

class GPSTUDIO_COM_EXPORT CameraInfo
{
public:
    CameraInfo(const QString &name=QString(), const QString &driverType=QString(), const QString &addr=QString());

    QString name() const;
    void setName(const QString &name);

    QString driverType() const;
    void setDriverType(const QString &driverType);

    QString addr() const;
    void setAddr(const QString &addr);

    const bool isValid() const;

    friend QDebug operator<< (QDebug d, const CameraInfo &cameraInfo);

private:
    QString _name;
    QString _driverType;
    QString _addr;
};

#endif // CAMERAINFO_H
