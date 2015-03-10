#include "property.h"

#include <QDebug>

Property::Property(QString name)
    : _name(name)
{
    _parent = NULL;
    _type = Group;
}

Property::Property(const Property &other)
    : QObject(), _name(other._name), _caption(other._caption), _value(other._value), _min(other._min), _max(other._max),
      _type(other._type), _parent(other._parent), _enums(other._enums), _subProperties(other._subProperties)
{
}

Property &Property::operator =(const Property &other)
{
    _name = other._name;
    _caption = other._caption;
    _value = other._value;
    _min = other._min;
    _max = other._max;
    _type = other._type;
    _parent = other._parent;
    _enums = other._enums;
    _subProperties = other._subProperties;
    return (*this);
}

Property::~Property()
{
    foreach (PropertyEnum *propertyEnum, _enums) delete propertyEnum;
}

QString Property::name() const
{
    return _name;
}

void Property::setName(const QString &name)
{
    _name = name;
}

QString Property::caption() const
{
    return _caption;
}

void Property::setCaption(const QString &caption)
{
    _caption = caption;
}

QVariant &Property::value()
{
    return _value;
}

void Property::setValue(bool value)
{
    setValue(QVariant(value));
}

void Property::setValue(int value)
{
    setValue(QVariant(value));
}

void Property::setValue(const QVariant &value)
{
    //qDebug()<<"Property::setValue"<<_name<<value<<_value;
    _value = value;
    emit valueChanged(QVariant(value));
}

QVariant Property::max() const
{
    return _max;
}

void Property::setMax(const QVariant &max)
{
    _max = max;
}

const QMap<QString, PropertyEnum *> &Property::enumsMap() const
{
    return _enumsMap;
}

const QList<PropertyEnum *> &Property::enums() const
{
    return _enums;
}

QVariant Property::min() const
{
    return _min;
}

void Property::setMin(const QVariant &min)
{
    _min = min;
}

Property::Type Property::type() const
{
    return _type;
}

void Property::setType(const Property::Type &type)
{
    _type = type;
}

Property &Property::operator[](const QString &name)
{
    return *_subProperties.propertiesMap()[name];
}

Property *Property::parent() const
{
    return _parent;
}

void Property::setParent(Property *parent)
{
    _parent = parent;
}

Property *Property::path(QString path)
{
    //qDebug()<<"path"<<path<<_name;
    if(path.isEmpty() || path==_name || path=="value") return this;
    int index = path.indexOf(".");
    if(index==-1)
    {
        if(_subProperties.propertiesMap().contains(path)) return _subProperties.propertiesMap()[path];
        else return NULL;
    }
    if(_subProperties.propertiesMap().contains(path.left(index))) return _subProperties.propertiesMap()[path.left(index)]->path(path.mid(index+1));
    return NULL;
}

const PropertiesMap &Property::subProperties() const
{
    return _subProperties;
}

void Property::addSubProperty(Property *property)
{
    property->setParent(this);
    _subProperties.addProperty(property);
}

Property *Property::fromBlockProperty(BlockProperty *blockProperty)
{
    Property *paramprop = new Property(blockProperty->name());
    paramprop->setCaption(blockProperty->caption());
    if(!blockProperty->propertyEnums().empty())
    {
        foreach (BlockPropertyEnum *blockPropertyEnum, blockProperty->propertyEnums())
        {
            PropertyEnum *propertyEnum = new PropertyEnum(blockPropertyEnum->name(), blockPropertyEnum->value());
            paramprop->_enumsMap.insert(blockPropertyEnum->name(), propertyEnum);
            paramprop->_enums.append(propertyEnum);
        }
        paramprop->setType(Property::Enum);
    }
    if(blockProperty->type()=="int" || blockProperty->type()=="sint")
    {
        if(blockProperty->type()=="int") paramprop->setType(Int);
        if(blockProperty->type()=="sint") paramprop->setType(SInt);
        paramprop->setValue(blockProperty->value().toInt());
        paramprop->setMin(blockProperty->min());
        paramprop->setMax(blockProperty->max());
    }
    if(blockProperty->type()=="bool") paramprop->setType(Bool);
    if(blockProperty->type()=="group") paramprop->setType(Group);

    foreach (BlockProperty *subBlockProperty, blockProperty->properties())
    {
        paramprop->addSubProperty(Property::fromBlockProperty(subBlockProperty));
    }

    return paramprop;
}
