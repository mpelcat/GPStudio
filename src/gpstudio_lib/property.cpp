#include "property.h"

Property::Property(QString name)
    : _name(name)
{
    _parent = NULL;
    _type = Group;
}

Property::~Property()
{
}

QString Property::name() const
{
    return _name;
}

void Property::setName(const QString &name)
{
    _name = name;
}

QString Property::caption() const
{
    return _caption;
}

void Property::setCaption(const QString &caption)
{
    _caption = caption;
}

QVariant &Property::value()
{
    return _value;
}

void Property::setValue(const QVariant &value)
{
    _value = value;
}

QVariant Property::max() const
{
    return _max;
}

void Property::setMax(const QVariant &max)
{
    _max = max;
}

QVariant Property::min() const
{
    return _min;
}

void Property::setMin(const QVariant &min)
{
    _min = min;
}

Property::Type Property::type() const
{
    return _type;
}

void Property::setType(const Property::Type &type)
{
    _type = type;
}

Property *Property::parent() const
{
    return _parent;
}

void Property::setParent(Property *parent)
{
    _parent = parent;
}

const PropertiesMap &Property::subProperties() const
{
    return _subProperties;
}

void Property::addSubProperty(Property *property)
{
    property->setParent(this);
    _subProperties.addProperty(property);
}
