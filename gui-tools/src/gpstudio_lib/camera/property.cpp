#include "property.h"

#include <QDebug>

#include "model/model_property.h"
#include "model/model_flow.h"

#include "camera.h"

Property::Property(QString name)
    : _name(name)
{
    _parent = NULL;
    _type = Group;
}

/*Property::Property(const Property &other)
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
}*/

Property::~Property()
{
    foreach (PropertyEnum *propertyEnum, _enumsMap) delete propertyEnum;
}

const QString &Property::name() const
{
    return _name;
}

void Property::setName(const QString &name)
{
    _name = name;
}

const QString &Property::caption() const
{
    return _caption;
}

void Property::setCaption(const QString &caption)
{
    _caption = caption;
}

const QVariant &Property::value() const
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
    bool valueChangedb = false;
    if(value != _value && _value.isValid()) valueChangedb=true;
    _value=value;

    if(_type==Matrix)
    {
        if(value.type()==QVariant::List)
        {
            int x=0;
            foreach (QVariant line, value.toList())
            {
                if(line.type()==QVariant::List)
                {
                    int y=0;
                    foreach (QVariant item, line.toList())
                    {
                        QString key = QString("m%1%2").arg(x).arg(y);
                        if(_subProperties.contains(key)) _subProperties[key]->setValue(item.toInt());
                        y++;
                    }
                }
                x++;
            }
        }
    }
    else
    {
        if(!_enumsMap.isEmpty())
        {
            if(_enumsMap.contains(value.toString()))
            {
                setBits(_enumsMap[value.toString()]->value().toUInt());
            }
        }
        else
        {
            setBits(value.toUInt());
        }
    }

    if(valueChangedb) emit valueChanged(QVariant(value));

    ScriptEngine::getEngine().evalPropertyMap(_onchange);
}

uint Property::bits() const
{
    return _bits;
}

void Property::setBits(const uint bits)
{
    if(bits != _bits)
    {
        _bits = bits;
        emit bitsChanged(bits);
    }
    else _bits = bits;
}

void Property::eval()
{
    setValue(ScriptEngine::getEngine().evalPropertyMap(_propertyMap));
}

const QVariant &Property::min() const
{
    return _min;
}

void Property::setMin(const QVariant &min)
{
    _min = min;
}

const QVariant &Property::max() const
{
    return _max;
}

void Property::setMax(const QVariant &max)
{
    _max = max;
}

const QVariant &Property::step() const
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

const QList<PropertyEnum *> Property::enums() const
{
    return _enumsMap.values();
}

Property::Type Property::type() const
{
    return _type;
}

void Property::setType(const Property::Type &type)
{
    _type = type;
}

const QString &Property::propertymap() const
{
    return _propertyMap;
}

void Property::setPropertymap(const QString &propertymap)
{
    _propertyMap = propertymap;
}

const QString &Property::onchange() const
{
    return _onchange;
}

void Property::setOnchange(const QString &onchange)
{
    _onchange = onchange;
}

Property &Property::operator[](const QString &name)
{
    return *_subProperties[name];
}

Property *Property::parent() const
{
    return _parent;
}

void Property::setParent(Property *parent)
{
    _parent = parent;
}

const Property *Property::path(const QString &path) const
{
    if(path.isEmpty() || path==_name || path=="value" || path=="bits") return this;
    int index = path.indexOf(".");
    if(index==-1)
    {
        if(_subProperties.contains(path)) return _subProperties[path];
        else return NULL;
    }
    if(_subProperties.contains(path.left(index))) return _subProperties[path.left(index)]->path(path.mid(index+1));
    return NULL;
}

QStringList Property::dependsProperties() const
{
    return ScriptEngine::dependsProperties(_propertyMap);
}

const QMap<QString, Property *> &Property::subProperties() const
{
    return _subProperties;
}

void Property::addSubProperty(Property *property)
{
    property->setParent(this);
    _subProperties.insert(property->name(), property);
}

Property *Property::fromModelProperty(ModelProperty *modelProperty)
{
    Property *paramprop = new Property(modelProperty->name());
    paramprop->setCaption(modelProperty->caption());
    paramprop->setOnchange(modelProperty->onchange());
    paramprop->setPropertymap(modelProperty->propertymap());
    if(!modelProperty->propertyEnums().empty())
    {
        foreach (ModelPropertyEnum *blockPropertyEnum, modelProperty->propertyEnums())
        {
            PropertyEnum *propertyEnum = new PropertyEnum(blockPropertyEnum->name(), blockPropertyEnum->value());
            paramprop->_enumsMap.insert(blockPropertyEnum->name(), propertyEnum);
        }
        paramprop->setType(Property::Enum);
        paramprop->setValue(modelProperty->value());
    }
    if(modelProperty->type()=="int" || modelProperty->type()=="sint")
    {
        if(modelProperty->type()=="int") paramprop->setType(Int);
        if(modelProperty->type()=="sint") paramprop->setType(SInt);
        paramprop->setValue(modelProperty->value().toInt());
        paramprop->setMin(modelProperty->min());
        paramprop->setMax(modelProperty->max());
        paramprop->setStep(modelProperty->step().toInt());
    }
    if(modelProperty->type()=="matrix")
    {
        paramprop->setType(Matrix);
        paramprop->setValue(QVariant(modelProperty->value()).toInt());
    }
    if(modelProperty->type()=="bool")
    {
        paramprop->setType(Bool);
        paramprop->setValue(QVariant(modelProperty->value()).toBool());
    }
    if(modelProperty->type()=="group") paramprop->setType(Group);

    // sub properties
    foreach (ModelProperty *subBlockProperty, modelProperty->properties())
    {
        paramprop->addSubProperty(Property::fromModelProperty(subBlockProperty));
    }

    return paramprop;
}

Property *Property::fromFlow(ModelFlow *modelFlow)
{
    Property *flowprop = new Property(modelFlow->name());
    flowprop->setCaption(modelFlow->name());
    flowprop->setType(FlowType);

    // sub properties
    foreach (ModelProperty *subBlockProperty, modelFlow->properties())
    {
        flowprop->addSubProperty(Property::fromModelProperty(subBlockProperty));
    }

    return flowprop;
}
