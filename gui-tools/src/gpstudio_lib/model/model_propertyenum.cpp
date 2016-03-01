#include "model_propertyenum.h"

ModelPropertyEnum::ModelPropertyEnum()
{
}

ModelPropertyEnum::~ModelPropertyEnum()
{
}

QString ModelPropertyEnum::name() const
{
    return _name;
}

void ModelPropertyEnum::setName(const QString &name)
{
    _name = name;
}

QVariant ModelPropertyEnum::value() const
{
    return _value;
}

void ModelPropertyEnum::setValue(const QVariant &value)
{
    _value = value;
}

QString ModelPropertyEnum::description() const
{
    return _description;
}

void ModelPropertyEnum::setDescription(const QString &description)
{
    _description = description;
}

ModelPropertyEnum *ModelPropertyEnum::fromNodeGenerated(const QDomElement &domElement)
{
    ModelPropertyEnum *blockPropertyEnum=new ModelPropertyEnum();

    blockPropertyEnum->setName(domElement.attribute("name","no_name"));

    QVariant value = domElement.attribute("value","");
    blockPropertyEnum->setValue(value);

    blockPropertyEnum->setDescription(domElement.attribute("desc",""));

    return blockPropertyEnum;
}

QList<ModelPropertyEnum *> ModelPropertyEnum::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<ModelPropertyEnum *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="enum") list.append(ModelPropertyEnum::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
