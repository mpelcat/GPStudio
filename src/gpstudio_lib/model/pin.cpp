#include "pin.h"

Pin::Pin()
{
}

Pin::~Pin()
{
}

QString Pin::name() const
{
    return _name;
}

void Pin::setName(const QString &name)
{
    _name = name;
}

QString Pin::mapTo() const
{
    return _mapTo;
}

void Pin::setMapTo(const QString &mapTo)
{
    _mapTo = mapTo;
}

Pin *Pin::fromNodeGenerated(const QDomElement &domElement)
{
    Pin *pin=new Pin();

    pin->setName(domElement.attribute("name","no_name"));
    pin->setMapTo(domElement.attribute("mapto",""));

    return pin;
}
