#include "blockproperty.h"

BlockProperty::BlockProperty()
{

}

BlockProperty::~BlockProperty()
{
    for(int i=0; i<_propertyEnums.size(); i++) delete _propertyEnums[i];
}

QString BlockProperty::name() const
{
    return _name;
}

void BlockProperty::setName(const QString &name)
{
    _name = name;
}

QString BlockProperty::caption() const
{
    return _caption;
}

void BlockProperty::setCaption(const QString &caption)
{
    _caption = caption;
}

QString BlockProperty::type() const
{
    return _type;
}

void BlockProperty::setType(const QString &type)
{
    _type = type;
}

QString BlockProperty::value() const
{
    return _value;
}

void BlockProperty::setValue(const QString &value)
{
    _value = value;
}

QString BlockProperty::min() const
{
    return _min;
}

void BlockProperty::setMin(const QString &min)
{
    _min = min;
}

QString BlockProperty::max() const
{
    return _max;
}

void BlockProperty::setMax(const QString &max)
{
    _max = max;
}

QString BlockProperty::step() const
{
    return _step;
}

void BlockProperty::setStep(const QString &step)
{
    _step = step;
}

QString BlockProperty::assert() const
{
    return _assert;
}

void BlockProperty::setAssert(const QString &assert)
{
    _assert = assert;
}

QString BlockProperty::description() const
{
    return _description;
}

void BlockProperty::setDescription(const QString &description)
{
    _description = description;
}

Block *BlockProperty::parent() const
{
    return _parent;
}

void BlockProperty::setParent(Block *parent)
{
    _parent = parent;
}

QList<BlockProperty *> &BlockProperty::properties()
{
    return _properties;
}

const QList<BlockProperty *> &BlockProperty::properties() const
{
    return _properties;
}

void BlockProperty::addProperty(BlockProperty *propertyEnum)
{
    _properties.append(propertyEnum);
}

QList<BlockPropertyEnum *> &BlockProperty::propertyEnums()
{
    return _propertyEnums;
}

const QList<BlockPropertyEnum *> &BlockProperty::propertyEnums() const
{
    return _propertyEnums;
}

void BlockProperty::addPropertyEnum(BlockPropertyEnum *propertyEnum)
{
    _propertyEnums.append(propertyEnum);
}

BlockProperty *BlockProperty::fromNodeGenerated(const QDomElement &domElement)
{
    BlockProperty *blockProperty=new BlockProperty();

    blockProperty->setName(domElement.attribute("name","no_name"));
    blockProperty->setCaption(domElement.attribute("caption",blockProperty->name()));
    if(blockProperty->caption().isEmpty()) blockProperty->setCaption(blockProperty->name());
    blockProperty->setType(domElement.attribute("type",""));
    blockProperty->setValue(domElement.attribute("value",""));
    blockProperty->setMin(domElement.attribute("min",""));
    blockProperty->setMax(domElement.attribute("max",""));
    blockProperty->setStep(domElement.attribute("step","1"));
    blockProperty->setAssert(domElement.attribute("assert",""));
    blockProperty->setDescription(domElement.attribute("desc",""));

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="properties") blockProperty->_properties.append(BlockProperty::listFromNodeGenerated(e));
            if(e.tagName()=="enums") blockProperty->_propertyEnums.append(BlockPropertyEnum::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return blockProperty;
}

QList<BlockProperty *> BlockProperty::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<BlockProperty *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="property") list.append(BlockProperty::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
