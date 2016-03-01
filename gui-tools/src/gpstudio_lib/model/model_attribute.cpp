#include "model_attribute.h"

ModelAttribute::ModelAttribute()
{
}

QString ModelAttribute::name() const
{
    return _name;
}

void ModelAttribute::setName(const QString &name)
{
    _name = name;
}

QString ModelAttribute::value() const
{
    return _value;
}

void ModelAttribute::setValue(const QString &value)
{
    _value = value;
}

QString ModelAttribute::type() const
{
    return _type;
}

void ModelAttribute::setType(const QString &type)
{
    _type = type;
}

ModelAttribute *ModelAttribute::fromNodeGenerated(const QDomElement &domElement)
{
    ModelAttribute *attribute=new ModelAttribute();

    attribute->setName(domElement.attribute("name","no_name"));
    attribute->setValue(domElement.attribute("value",""));
    attribute->setType(domElement.attribute("type",""));

    return attribute;
}

QList<ModelAttribute *> ModelAttribute::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<ModelAttribute *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="attribute") list.append(ModelAttribute::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
