/****************************************************************************
** Copyright (C) 2016 Dream IP
** 
** This file is part of GPStudio.
**
** GPStudio is a free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program.  If not, see <http://www.gnu.org/licenses/>.
**
****************************************************************************/

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
    _row = 0;
    _bits = 0;
    _modelProperty = NULL;
}

Property::~Property()
{
    foreach (Property *property, _subProperties)
        delete property;
    foreach (PropertyEnum *propertyEnum, _enumsMap)
        delete propertyEnum;
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
                        if(_subPropertiesMap.contains(key)) _subPropertiesMap[key]->setValue(item.toInt());
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
    if(_propertyMap.isEmpty())
        return;

    QScriptValue value = ScriptEngine::getEngine().eval(_propertyMap);
    if(!value.isError())
        setValue(value.toVariant());
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
    return *path(name);
}

const QList<Property *> &Property::subProperties() const
{
    return _subProperties;
}

Property *Property::parent() const
{
    return _parent;
}

const ModelProperty *Property::modelProperty() const
{
    return _modelProperty;
}

void Property::setParent(Property *parent)
{
    _parent = parent;
}

int Property::row() const
{
    return _row;
}

void Property::setRow(int row)
{
    _row = row;
}

Property *Property::path(const QString &path) const
{
    if(path.isEmpty() || path=="value" || path=="bits")
        return (Property *)this;
    int index = path.indexOf(".");
    if(index==-1)
    {
        if(_subPropertiesMap.contains(path))
            return _subPropertiesMap[path];
        else return NULL;
    }
    if(_subPropertiesMap.contains(path.left(index)))
        return _subPropertiesMap[path.left(index)]->path(path.mid(index+1));
    return NULL;
}

QVariant Property::property(const QString &path) const
{
    Property *prop = this->path(path);
    if(prop)
        return prop->value();
    return QVariant();
}

QStringList Property::dependsProperties() const
{
    return ScriptEngine::dependsProperties(_propertyMap);
}

const QMap<QString, Property *> &Property::subPropertiesMap() const
{
    return _subPropertiesMap;
}

void Property::addSubProperty(Property *property)
{
    property->setParent(this);
    property->setRow(_subProperties.count());
    _subPropertiesMap.insert(property->name(), property);
    _subProperties.append(property);
}

void Property::removeAllSubProperties()
{
    foreach (Property *property, _subProperties) delete property;
    _subPropertiesMap.clear();
    _subProperties.clear();
}

Property *Property::fromModelProperty(const ModelProperty *modelProperty)
{
    Property *paramprop = new Property(modelProperty->name());
    paramprop->setCaption(modelProperty->caption());
    paramprop->setOnchange(modelProperty->onchange());
    paramprop->setPropertymap(modelProperty->propertymap());
    paramprop->_modelProperty = modelProperty;
    if(!modelProperty->propertyEnums().empty())
    {
        foreach (ModelPropertyEnum *blockPropertyEnum, modelProperty->propertyEnums())
        {
            PropertyEnum *propertyEnum = new PropertyEnum(blockPropertyEnum->name(), blockPropertyEnum->caption(), blockPropertyEnum->value());
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
    if(modelProperty->type()=="string")
    {
        paramprop->setType(String);
        paramprop->setValue(modelProperty->value());
    }
    if(modelProperty->type()=="flowtype")
    {
        paramprop->setType(FlowDataType);
        paramprop->setValue(modelProperty->value());
    }

    // sub properties
    foreach (ModelProperty *subBlockProperty, modelProperty->properties())
    {
        paramprop->addSubProperty(Property::fromModelProperty(subBlockProperty));
    }

    return paramprop;
}

Property *Property::fromModelFlow(const ModelFlow *modelFlow)
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

Property *Property::fromModelBlock(const ModelBlock *modelBlock)
{
    Property *propBlock = new Property(modelBlock->name());
    propBlock->setCaption(modelBlock->name() + " (" + modelBlock->driver() + ")");
    propBlock->setType(BlockType);

    return propBlock;
}
