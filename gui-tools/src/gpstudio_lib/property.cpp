#include "property.h"

#include <QDebug>

Property::Property(QString name)
    : _name(name)
{
    _parent = NULL;
    _type = Group;
    _engine = NULL;
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
    _engine = other._engine;
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
    _value = value;
    if(!_enums.isEmpty())
    {
        if(_enumsMap.contains(value.toString()))
        {
            setBits(_enumsMap[value.toString()]->value().toUInt());
        }
    }
    else
    {
        setBits(_value.toUInt());
    }
    emit valueChanged(QVariant(value));

    if(_engine)
    {
        _engine->evalPropertyMap(_onchange, _blockName);
    }
}

uint Property::bits() const
{
    return _bits;
}

void Property::setBits(const uint bits)
{
    _bits = bits;
    emit bitsChanged(bits);
}

QVariant Property::min() const
{
    return _min;
}

void Property::setMin(const QVariant &min)
{
    _min = min;
}

QVariant Property::max() const
{
    return _max;
}

void Property::setMax(const QVariant &max)
{
    _max = max;
}

QVariant Property::step() const
{
    return _step;
}

void Property::setStep(const QVariant &step)
{
    _step = step;
}

const QMap<QString, PropertyEnum *> &Property::enumsMap() const
{
    return _enumsMap;
}

const QList<PropertyEnum *> &Property::enums() const
{
    return _enums;
}

Property::Type Property::type() const
{
    return _type;
}

void Property::setType(const Property::Type &type)
{
    _type = type;
}

QString Property::blockName() const
{
    return _blockName;
}

void Property::setBlockName(const QString &blockName)
{
    _blockName = blockName;
}

QString Property::propertymap() const
{
    return _propertyMap;
}

void Property::setPropertymap(const QString &propertymap)
{
    _propertyMap = propertymap;
}

QString Property::onchange() const
{
    return _onchange;
}

void Property::setOnchange(const QString &onchange)
{
    _onchange = onchange;
}

ScriptEngine *Property::engine() const
{
    return _engine;
}

void Property::setEngine(ScriptEngine *engine)
{
    _engine = engine;
    foreach (Property *property, _subProperties.properties())
    {
        property->setEngine(_engine);
    }
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
    if(path.isEmpty() || path==_name || path=="value" || path=="bits") return this;
    int index = path.indexOf(".");
    if(index==-1)
    {
        if(_subProperties.propertiesMap().contains(path)) return _subProperties.propertiesMap()[path];
        else return NULL;
    }
    if(_subProperties.propertiesMap().contains(path.left(index))) return _subProperties.propertiesMap()[path.left(index)]->path(path.mid(index+1));
    return NULL;
}

QStringList Property::dependsProperties() const
{
    return ScriptEngine::dependsProperties(_propertyMap);
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

Property *Property::fromBlockProperty(BlockProperty *blockProperty, Block *block)
{
    Property *paramprop = new Property(blockProperty->name());
    paramprop->setCaption(blockProperty->caption());
    paramprop->setOnchange(blockProperty->onchange());
    paramprop->setBlockName(block->name());
    paramprop->setPropertymap(blockProperty->propertymap());
    if(!blockProperty->propertyEnums().empty())
    {
        foreach (BlockPropertyEnum *blockPropertyEnum, blockProperty->propertyEnums())
        {
            PropertyEnum *propertyEnum = new PropertyEnum(blockPropertyEnum->name(), blockPropertyEnum->value());
            paramprop->_enumsMap.insert(blockPropertyEnum->name(), propertyEnum);
            paramprop->_enums.append(propertyEnum);
        }
        paramprop->setType(Property::Enum);
        paramprop->setValue(blockProperty->value());
    }
    if(blockProperty->type()=="int" || blockProperty->type()=="sint")
    {
        if(blockProperty->type()=="int") paramprop->setType(Int);
        if(blockProperty->type()=="sint") paramprop->setType(SInt);
        paramprop->setValue(blockProperty->value().toInt());
        paramprop->setMin(blockProperty->min());
        paramprop->setMax(blockProperty->max());
        paramprop->setStep(blockProperty->step().toInt());
    }
    if(blockProperty->type()=="matrix")
    {
        paramprop->setType(Matrix);
        paramprop->setValue(QVariant(blockProperty->value()).toInt());
    }
    if(blockProperty->type()=="bool")
    {
        paramprop->setType(Bool);
        paramprop->setValue(QVariant(blockProperty->value()).toBool());
    }
    if(blockProperty->type()=="group") paramprop->setType(Group);

    // sub properties
    foreach (BlockProperty *subBlockProperty, blockProperty->properties())
    {
        paramprop->addSubProperty(Property::fromBlockProperty(subBlockProperty, block));
    }

    return paramprop;
}
