#include "blockpropertyenum.h"

BlockPropertyEnum::BlockPropertyEnum()
{
}

BlockPropertyEnum::~BlockPropertyEnum()
{
}

QString BlockPropertyEnum::name() const
{
    return _name;
}

void BlockPropertyEnum::setName(const QString &name)
{
    _name = name;
}

QVariant BlockPropertyEnum::value() const
{
    return _value;
}

void BlockPropertyEnum::setValue(const QVariant &value)
{
    _value = value;
}

QString BlockPropertyEnum::description() const
{
    return _description;
}

void BlockPropertyEnum::setDescription(const QString &description)
{
    _description = description;
}

BlockPropertyEnum *BlockPropertyEnum::fromNodeGenerated(const QDomElement &domElement)
{
    BlockPropertyEnum *blockPropertyEnum=new BlockPropertyEnum();

    blockPropertyEnum->setName(domElement.attribute("name","no_name"));

    QVariant value = domElement.attribute("value","");
    blockPropertyEnum->setValue(value);

    blockPropertyEnum->setDescription(domElement.attribute("desc",""));

    return blockPropertyEnum;
}

QList<BlockPropertyEnum *> BlockPropertyEnum::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<BlockPropertyEnum *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="enum") list.append(BlockPropertyEnum::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
