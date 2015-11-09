#include "parambitfield.h"

#include <QRegExp>
#include <QStringList>
#include <QDebug>

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

QString ParamBitField::propertyMap() const
{
    return _propertyMap;
}

void ParamBitField::setPropertyMap(const QString &propertyMap)
{
    _propertyMap = propertyMap;
}

Param *ParamBitField::parent() const
{
    return _parent;
}

void ParamBitField::setParent(Param *parent)
{
    _parent = parent;
}

ParamBitField *ParamBitField::fromNodeGenerated(const QDomElement &domElement)
{
    ParamBitField *paramBitField=new ParamBitField();

    paramBitField->setName(domElement.attribute("name","no_name"));
    paramBitField->setType(domElement.attribute("type",""));

    QVariant value = domElement.attribute("value","");
    paramBitField->setValue(value);

    paramBitField->setBitfield(domElement.attribute("bitfield",""));
    paramBitField->setPropertyMap(domElement.attribute("propertymap",""));
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

QList<uint> ParamBitField::listBitFromBitField(const QString &bitField)
{
    QList<uint> bits;
    if(bitField.isEmpty()) return QList<uint>();

    QString lastSymbole = "";
    int previous = -1;

    QRegExp exp("([-,]?)([0-9]+)");
    int pos=0;
    while((pos = exp.indexIn(bitField, pos)) != -1)
    {
        QString symbole = exp.cap(1);
        int bit = exp.cap(2).toUInt();

        if(bit>31) return QList<uint>();

        if(symbole==",")
        {
            if(lastSymbole=="," || lastSymbole=="")
            {
                if(previous==-1) return QList<uint>();
                bits.append(previous);
            }
        }
        else if(symbole=="-")
        {
            if(previous<bit) return QList<uint>();
            for(int i=previous; i>=bit; i--) bits.append(i);
        }

        previous = bit;
        lastSymbole = symbole;

        pos += exp.matchedLength();
    }

    if((lastSymbole=="," || lastSymbole=="") and previous!=-1) bits.append(previous);

    return bits;
}
