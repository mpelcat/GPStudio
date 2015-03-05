#include "cameraproperty.h"

#include <QDebug>
#include <QVariant>

CameraProperty::CameraProperty(QString name)
    : Property(name)
{

}

CameraProperty::~CameraProperty()
{

}
unsigned int CameraProperty::getAddr() const
{
    return addr;
}

void CameraProperty::setAddr(unsigned int value)
{
    addr = value;
}

CameraProperty *CameraProperty::fromBlockProperty(BlockProperty *blockProperty)
{
    CameraProperty *paramprop = new CameraProperty(blockProperty->name());
    paramprop->setCaption(blockProperty->caption());
    if(!blockProperty->propertyEnums().empty())
    {
        QMap<QString, QVariant> enums;
        foreach (BlockPropertyEnum *blockPropertyEnum, blockProperty->propertyEnums())
        {
            enums.insert(blockPropertyEnum->name(), blockPropertyEnum->value());
        }
        QVariant varEnums(enums);
        paramprop->setValue(varEnums);
        paramprop->setType(Property::Enum);
        //qDebug()<<varEnums;
    }
    if(blockProperty->type()=="int" || blockProperty->type()=="sint")
    {
        if(blockProperty->type()=="int") paramprop->setType(Int);
        if(blockProperty->type()=="sint") paramprop->setType(SInt);
        paramprop->setValue(blockProperty->value());
        paramprop->setMin(blockProperty->min());
        paramprop->setMax(blockProperty->max());
        if(blockProperty->name()=="YEND") qDebug()<<paramprop->min()<<paramprop->max()<<paramprop->value();
    }
    if(blockProperty->type()=="bool") paramprop->setType(Bool);
    return paramprop;
}

