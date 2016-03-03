#ifndef PROPERTYENUM_H
#define PROPERTYENUM_H

#include "gpstudio_lib_common.h"

#include <QVariant>
#include <QString>

class GPSTUDIO_LIB_EXPORT PropertyEnum
{
public:
    PropertyEnum(const QString &name=QString(), const QVariant &value=QVariant());
    ~PropertyEnum();

    QString name() const;
    void setName(const QString &name);

    QVariant value() const;
    void setValue(const QVariant &value);

private:
    QString _name;
    QVariant _value;
};

#endif // PROPERTYENUM_H
