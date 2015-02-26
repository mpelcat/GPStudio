#include "paramenum.h"

ParamEnum::ParamEnum()
{
}

ParamEnum::~ParamEnum()
{
}

QString ParamEnum::name() const
{
    return _name;
}

void ParamEnum::setName(const QString &name)
{
    _name = name;
}

QVariant ParamEnum::value() const
{
    return _value;
}

void ParamEnum::setValue(const QVariant &value)
{
    _value = value;
}

QString ParamEnum::description() const
{
    return _description;
}

void ParamEnum::setDescription(const QString &description)
{
    _description = description;
}

ParamEnum *ParamEnum::fromNodeGenerated(const QDomElement &domElement)
{
    ParamEnum *paramEnum=new ParamEnum();

    paramEnum->setName(domElement.attribute("name","no_name"));

    QVariant value = domElement.attribute("value","");
    paramEnum->setValue(value);

    paramEnum->setDescription(domElement.attribute("desc",""));

    return paramEnum;
}
