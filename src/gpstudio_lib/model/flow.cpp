#include "flow.h"

#include "block.h"

Flow::Flow(Block *parent)
    : _parent(parent)
{
}

Flow::~Flow()
{
}

QString Flow::name() const
{
    return _name;
}

void Flow::setName(const QString &name)
{
    _name = name;
}

QString Flow::type() const
{
    return _type;
}

void Flow::setType(const QString &type)
{
    _type = type;
}

quint8 Flow::size() const
{
    return _size;
}

void Flow::setSize(const quint8 &size)
{
    _size = size;
}

QString Flow::description() const
{
    return _description;
}

void Flow::setDescription(const QString &description)
{
    _description = description;
}

Block *Flow::parent() const
{
    return _parent;
}

void Flow::setParent(Block *parent)
{
    _parent = parent;
}

Flow *Flow::fromNodeGenerated(const QDomElement &domElement)
{
    Flow *flow=new Flow();
    bool ok=false;

    flow->setName(domElement.attribute("name","no_name"));
    flow->setType(domElement.attribute("type",""));

    int size = domElement.attribute("size","0").toInt(&ok);
    if(ok && size>=0) flow->setSize(size); else flow->setSize(0);

    flow->setDescription(domElement.attribute("desc",""));

    return flow;
}
