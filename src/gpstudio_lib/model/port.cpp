#include "port.h"

Port::Port()
{
}

Port::~Port()
{
}

QString Port::name() const
{
    return _name;
}

void Port::setName(const QString &name)
{
    _name = name;
}

QString Port::type() const
{
    return _type;
}

void Port::setType(const QString &type)
{
    _type = type;
}

quint8 Port::size() const
{
    return _size;
}

void Port::setSize(const quint8 &size)
{
    _size = size;
}

QString Port::description() const
{
    return _description;
}

void Port::setDescription(const QString &description)
{
    _description = description;
}

Port *Port::fromNodeGenerated(const QDomElement &domElement)
{
    Port *port=new Port();
    bool ok=false;

    port->setName(domElement.attribute("name","no_name"));
    port->setType(domElement.attribute("type",""));

    int size = domElement.attribute("size","0").toInt(&ok);
    if(ok && size>=0) port->setSize(size); else port->setSize(0);

    port->setDescription(domElement.attribute("desc",""));

    return port;
}
