#include "param.h"

#include "block.h"

Param::Param(Block *parent)
    : _parent(parent)
{
}

Param::~Param()
{
    for(int i=0; i<_parambitfields.size(); i++) delete _parambitfields[i];
}

QString Param::name() const
{
    return _name;
}

void Param::setName(const QString &name)
{
    _name = name;
}

QString Param::type() const
{
    return _type;
}

void Param::setType(const QString &type)
{
    _type = type;
}

qint32 Param::regAddr() const
{
    return _regAddr;
}

void Param::setRegAddr(const qint32 &regAddr)
{
    _regAddr = regAddr;
}

qint32 Param::absoluteAddr() const
{
    if(_parent) return _parent->addrAbs()+_regAddr;
    return _regAddr;
}

const QVariant &Param::value() const
{
    return _value;
}

void Param::setValue(const QVariant &value)
{
    _value = value;
}

QVariant Param::defaultValue() const
{
    return _defaultValue;
}

void Param::setDefaultValue(const QVariant &defaultValue)
{
    _defaultValue = defaultValue;
}

const QVariant &Param::min() const
{
    return _min;
}

void Param::setMin(const QVariant &min)
{
    _min = min;
}

const QVariant &Param::max() const
{
    return _max;
}

void Param::setMax(const QVariant &max)
{
    _max = max;
}

bool Param::isHard() const
{
    return _hard;
}

void Param::setHard(bool hard)
{
    _hard = hard;
}

QString Param::propertyMap() const
{
    return _propertyMap;
}

void Param::setPropertyMap(const QString &propertyMap)
{
    _propertyMap = propertyMap;
}

QString Param::description() const
{
    return _description;
}

void Param::setDescription(const QString &description)
{
    _description = description;
}

Block *Param::parent() const
{
    return _parent;
}

void Param::setParent(Block *parent)
{
    _parent = parent;
}

bool Param::isDynamicParam() const
{
    return (!_hard && _regAddr>=0);
}

QList<ParamBitField *> &Param::paramBitFields()
{
    return _parambitfields;
}

const QList<ParamBitField *> &Param::paramBitFields() const
{
    return _parambitfields;
}

void Param::addParamBitField(ParamBitField *bitField)
{
    bitField->setParent(this);
    _parambitfields.append(bitField);
}

void Param::addParamBitFields(const QList<ParamBitField *> &bitFields)
{
    foreach (ParamBitField *bitField, bitFields)
    {
        addParamBitField(bitField);
    }
}

Param *Param::fromNodeGenerated(const QDomElement &domElement)
{
    Param *param=new Param();
    bool ok=false;

    param->setName(domElement.attribute("name","no_name"));
    param->setType(domElement.attribute("type",""));

    int regaddr = domElement.attribute("regaddr","-1").toInt(&ok);
    if(ok) param->setRegAddr(regaddr); else param->setRegAddr(-1);

    int value = domElement.attribute("value","0").toInt(&ok);
    if(ok) param->setValue(value); else param->setValue(0);

    int defaultValue = domElement.attribute("default","0").toInt(&ok);
    if(ok) param->setDefaultValue(defaultValue); else param->setDefaultValue(0);

    int min = domElement.attribute("min","0").toInt(&ok);
    if(ok) param->setMin(min); else param->setMin(0);

    int max = domElement.attribute("max","0").toInt(&ok);
    if(ok) param->setMax(max); else param->setMax(0);

    param->setPropertyMap(domElement.attribute("propertymap",""));

    param->setHard((domElement.attribute("hard","")=="1" || domElement.attribute("hard","")=="true"));

    param->setDescription(domElement.attribute("desc",""));

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="bitfields") param->addParamBitFields(ParamBitField::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return param;
}

QList<Param *> Param::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<Param *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="param") list.append(Param::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
