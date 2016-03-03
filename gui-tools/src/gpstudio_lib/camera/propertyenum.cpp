#include "propertyenum.h"

PropertyEnum::PropertyEnum(const QString &name, const QVariant &value)
    : _name(name), _value(value)
{
}

PropertyEnum::~PropertyEnum()
{
}

QString PropertyEnum::name() const
{
    return _name;
}

void PropertyEnum::setName(const QString &name)
{
    _name = name;
}

QVariant PropertyEnum::value() const
{
    return _value;
}

void PropertyEnum::setValue(const QVariant &value)
{
    _value = value;
}
