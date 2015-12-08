#include "port.h"

#include "block.h"

Port::Port(Block *parent)
    : _parent(parent)
{
    _parent = NULL;
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

Block *Port::parent() const
{
    return _parent;
}

void Port::setParent(Block *parent)
{
    _parent = parent;
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

QList<Port *> Port::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<Port *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="port") list.append(Port::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
