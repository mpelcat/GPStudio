#include "pin.h"

#include "block.h"

Pin::Pin(Block *parent)
    : _parent(parent)
{
}

Pin::~Pin()
{
    for(int i=0; i<_attributes.size(); i++) delete _attributes[i];
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

Block *Pin::parent() const
{
    return _parent;
}

void Pin::setParent(Block *parent)
{
    _parent = parent;
}

QList<Attribute *> &Pin::attributes()
{
    return _attributes;
}

const QList<Attribute *> &Pin::attributes() const
{
    return _attributes;
}

void Pin::addAttribute(Attribute *attribute)
{
    _attributes.append(attribute);
}

Pin *Pin::fromNodeGenerated(const QDomElement &domElement)
{
    Pin *pin=new Pin();

    pin->setName(domElement.attribute("name","no_name"));
    pin->setMapTo(domElement.attribute("mapto",""));

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="attributes") pin->_attributes.append(Attribute::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return pin;
}

QList<Pin *> Pin::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<Pin *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="pin") list.append(Pin::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
