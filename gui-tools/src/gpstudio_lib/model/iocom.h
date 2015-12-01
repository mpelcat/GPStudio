#ifndef IOCOM_H
#define IOCOM_H

#include "gpstudio_lib_common.h"

#include "io.h"

#include "comconnect.h"

class GPSTUDIO_LIB_EXPORT IOCom : public IO
{
public:
    IOCom();
    ~IOCom();

    QString type() const;

    QString driverIO() const;
    void setDriverIO(const QString &driverIO);

    void addComConnect(ComConnect *comConnect);
    void addComConnects(const QList<ComConnect *> &comConnects);
    QList<ComConnect *> comConnects();
    const QList<ComConnect *> comConnects() const;

public:
    static IO *fromNodeGenerated(const QDomElement &domElement, IOCom *ioCom=NULL);

protected:
    QString _driverIO;

    QList<ComConnect *> _comConnects;
};

#endif // IOCOM_H
