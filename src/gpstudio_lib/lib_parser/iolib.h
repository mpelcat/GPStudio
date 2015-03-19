#ifndef IOLIB_H
#define IOLIB_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QDomElement>
#include <QList>

class GPSTUDIO_LIB_EXPORT IOLib
{
public:
    IOLib();
    ~IOLib();

    QString name() const;
    void setName(const QString &name);

    QString type() const;
    void setType(const QString &type);

    QString driver() const;
    void setDriver(const QString &driver);

    bool isOptional() const;
    void setOptional(bool isOptional);

    QString group() const;
    void setGroup(const QString &group);

    QString description() const;
    void setDescription(const QString &description);

public:
    static IOLib *fromNodeGenerated(const QDomElement &domElement);
    static QList<IOLib *> listFromNodeGenerated(const QDomElement &domElement);

private:
    QString _name;
    QString _type;
    QString _driver;
    bool _optional;
    QString _group;
    QString _description;
};

#endif // IOLIB_H
