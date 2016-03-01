#include "model_flow.h"

#include "model_block.h"

#include <QDebug>

ModelFlow::ModelFlow(ModelBlock *parent)
    : _parent(parent)
{
    _parent = NULL;
}

ModelFlow::~ModelFlow()
{
}

const QString &ModelFlow::name() const
{
    return _name;
}

void ModelFlow::setName(const QString &name)
{
    _name = name;
}

QString ModelFlow::type() const
{
    return _type;
}

void ModelFlow::setType(const QString &type)
{
    _type = type;
}

quint8 ModelFlow::size() const
{
    return _size;
}

void ModelFlow::setSize(const quint8 &size)
{
    _size = size;
}

QString ModelFlow::description() const
{
    return _description;
}

void ModelFlow::setDescription(const QString &description)
{
    _description = description;
}

ModelBlock *ModelFlow::parent() const
{
    return _parent;
}

void ModelFlow::setParent(ModelBlock *parent)
{
    _parent = parent;
    foreach (ModelProperty *property, _properties)
    {
        property->setParent(_parent);
    }
}

QList<ModelProperty *> &ModelFlow::properties()
{
    return _properties;
}

const QList<ModelProperty *> &ModelFlow::properties() const
{
    return _properties;
}

void ModelFlow::addProperty(ModelProperty *property)
{
    property->setParent(_parent);
    _properties.append(property);
}

void ModelFlow::addProperties(const QList<ModelProperty *> &properties)
{
    foreach (ModelProperty *property, properties)
    {
        addProperty(property);
    }
}

ModelProperty *ModelFlow::getBlockProperty(const QString &name) const
{
    for(int i=0; i<this->properties().size(); i++)
    {
        ModelProperty *blockProperty = this->properties().at(i);
        if(blockProperty->name()==name) return blockProperty;
    }
    return NULL;
}

ModelFlow *ModelFlow::fromNodeGenerated(const QDomElement &domElement)
{
    ModelFlow *flow=new ModelFlow();
    bool ok=false;

    flow->setName(domElement.attribute("name","no_name"));
    flow->setType(domElement.attribute("type",""));

    int size = domElement.attribute("size","0").toInt(&ok);
    if(ok && size>=0) flow->setSize(size); else flow->setSize(0);

    flow->setDescription(domElement.attribute("desc",""));

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="properties") flow->addProperties(ModelProperty::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return flow;
}

QList<ModelFlow *> ModelFlow::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<ModelFlow *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="flow") list.append(ModelFlow::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
