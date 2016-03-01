#include "model_pin.h"

#include "model_block.h"

ModelPin::ModelPin(ModelBlock *parent)
    : _parent(parent)
{
    _parent = NULL;
}

ModelPin::~ModelPin()
{
    for(int i=0; i<_attributes.size(); i++) delete _attributes[i];
}

QString ModelPin::name() const
{
    return _name;
}

void ModelPin::setName(const QString &name)
{
    _name = name;
}

QString ModelPin::mapTo() const
{
    return _mapTo;
}

void ModelPin::setMapTo(const QString &mapTo)
{
    _mapTo = mapTo;
}

ModelBlock *ModelPin::parent() const
{
    return _parent;
}

void ModelPin::setParent(ModelBlock *parent)
{
    _parent = parent;
}

QList<ModelAttribute *> &ModelPin::attributes()
{
    return _attributes;
}

const QList<ModelAttribute *> &ModelPin::attributes() const
{
    return _attributes;
}

void ModelPin::addAttribute(ModelAttribute *attribute)
{
    _attributes.append(attribute);
}

ModelPin *ModelPin::fromNodeGenerated(const QDomElement &domElement)
{
    ModelPin *pin=new ModelPin();

    pin->setName(domElement.attribute("name","no_name"));
    pin->setMapTo(domElement.attribute("mapto",""));

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="attributes") pin->_attributes.append(ModelAttribute::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return pin;
}

QList<ModelPin *> ModelPin::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<ModelPin *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="pin") list.append(ModelPin::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
