#ifndef IOLIBGROUP_H
#define IOLIBGROUP_H

#include "gpstudio_lib_common.h"

#include <QString>
#include <QStringList>
#include <QList>

class GPSTUDIO_LIB_EXPORT IOLibGroup
{
public:
    IOLibGroup(const QString &name=QString());
    ~IOLibGroup();

    QString name() const;
    void setName(const QString &name);

    bool isOptional() const;
    void setOptional(bool isOptional);

    const QStringList &ios() const;
    void addIos(const QString &name);

private:
    QString _name;
    QStringList _ios;
    bool _optional;
};

#endif // IOLIBGROUP_H
