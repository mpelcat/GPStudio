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

    // attributes
    const QDomNodeList &attributesNodeList = domElement.elementsByTagName("attributes");
    for(int i=0; i<attributesNodeList.length(); i++)
    {
        const QDomElement &attributesNode = attributesNodeList.at(i).toElement();
        const QDomNodeList &attributeNodeList = attributesNode.elementsByTagName("attribute");
        for(int j=0; j<attributeNodeList.length(); j++)
        {
            const QDomElement &attributeNode = attributeNodeList.at(j).toElement();
            Attribute *attribute = Attribute::fromNodeGenerated(attributeNode);
            pin->addAttribute(attribute);
        }
    }

    return pin;
}
