#include "parambitfield.h"

ParamBitField::ParamBitField()
{
}

ParamBitField::~ParamBitField()
{
}

QString ParamBitField::name() const
{
    return _name;
}

void ParamBitField::setName(const QString &name)
{
    _name = name;
}

QString ParamBitField::type() const
{
    return _type;
}

void ParamBitField::setType(const QString &type)
{
    _type = type;
}

QVariant ParamBitField::value() const
{
    return _value;
}

void ParamBitField::setValue(const QVariant &value)
{
    _value = value;
}

QString ParamBitField::bitfield() const
{
    return _bitfield;
}

void ParamBitField::setBitfield(const QString &bitfield)
{
    _bitfield = bitfield;
}

QString ParamBitField::description() const
{
    return _description;
}

void ParamBitField::setDescription(const QString &description)
{
    _description = description;
}

ParamBitField *ParamBitField::fromNodeGenerated(const QDomElement &domElement)
{
    ParamBitField *paramBitField=new ParamBitField();

    paramBitField->setName(domElement.attribute("name","no_name"));
    paramBitField->setType(domElement.attribute("type",""));

    QVariant value = domElement.attribute("value","");
    paramBitField->setValue(value);

    paramBitField->setBitfield(domElement.attribute("bitfield",""));
    paramBitField->setDescription(domElement.attribute("desc",""));

    return paramBitField;
}

QList<ParamBitField *> ParamBitField::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<ParamBitField *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="bitfield") list.append(ParamBitField::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
