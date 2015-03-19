#include "iolibgroup.h"

IOLibGroup::IOLibGroup(const QString &name)
    : _name(name)
{
}

IOLibGroup::~IOLibGroup()
{
}

QString IOLibGroup::name() const
{
    return _name;
}

void IOLibGroup::setName(const QString &name)
{
    _name = name;
}

bool IOLibGroup::isOptional() const
{
    return _optional;
}

void IOLibGroup::setOptional(bool isOptional)
{
    _optional = isOptional;
}

const QStringList &IOLibGroup::ios() const
{
    return _ios;
}

void IOLibGroup::addIos(const QString &name)
{
    _ios.append(name);
}


