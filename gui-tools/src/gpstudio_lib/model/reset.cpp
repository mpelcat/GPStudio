#include "reset.h"

#include "block.h"

Reset::Reset(Block *parent)
    : _parent(parent)
{
    _parent = NULL;
}

Reset::~Reset()
{
}

QString Reset::name() const
{
    return _name;
}

void Reset::setName(const QString &name)
{
    _name = name;
}

QString Reset::group() const
{
    return _group;
}

void Reset::setGroup(const QString &group)
{
    _group = group;
}

Reset::Direction Reset::direction() const
{
    return _direction;
}

void Reset::setDirection(const Reset::Direction &direction)
{
    _direction = direction;
}

QString Reset::description() const
{
    return _description;
}

void Reset::setDescription(const QString &description)
{
    _description = description;
}

Block *Reset::parent() const
{
    return _parent;
}

void Reset::setParent(Block *parent)
{
    _parent = parent;
}

Reset *Reset::fromNodeGenerated(const QDomElement &domElement)
{
    Reset *reset=new Reset();

    reset->setName(domElement.attribute("name","no_name"));
    reset->setGroup(domElement.attribute("group",""));

    QString direction = domElement.attribute("direction","");
    if(direction.toLower()=="in") reset->setDirection(DirIn);
    else if(direction.toLower()=="out") reset->setDirection(DirOut);
    else reset->setDirection(DirUndef);

    reset->setDescription(domElement.attribute("desc",""));

    return reset;
}

QList<Reset *> Reset::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<Reset *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="reset") list.append(Reset::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
