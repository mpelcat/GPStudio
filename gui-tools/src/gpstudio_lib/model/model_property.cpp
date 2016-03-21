/****************************************************************************
** Copyright (C) 2014 Dream IP
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

#include "model_property.h"

#include <QDebug>

ModelProperty::ModelProperty()
{
    _parent = NULL;
}

ModelProperty::~ModelProperty()
{
    for(int i=0; i<_propertyEnums.size(); i++) delete _propertyEnums[i];
}

QString ModelProperty::name() const
{
    return _name;
}

void ModelProperty::setName(const QString &name)
{
    _name = name;
}

QString ModelProperty::caption() const
{
    return _caption;
}

void ModelProperty::setCaption(const QString &caption)
{
    _caption = caption;
}

QString ModelProperty::type() const
{
    return _type;
}

void ModelProperty::setType(const QString &type)
{
    _type = type;
}

QString ModelProperty::value() const
{
    return _value;
}

void ModelProperty::setValue(const QString &value)
{
    _value = value;
}

QString ModelProperty::min() const
{
    return _min;
}

void ModelProperty::setMin(const QString &min)
{
    _min = min;
}

QString ModelProperty::max() const
{
    return _max;
}

void ModelProperty::setMax(const QString &max)
{
    _max = max;
}

QString ModelProperty::step() const
{
    return _step;
}

void ModelProperty::setStep(const QString &step)
{
    _step = step;
}

QString ModelProperty::assert() const
{
    return _assert;
}

void ModelProperty::setAssert(const QString &assert)
{
    _assert = assert;
}

QString ModelProperty::propertymap() const
{
    return _propertymap;
}

void ModelProperty::setPropertymap(const QString &propertymap)
{
    _propertymap = propertymap;
}

QString ModelProperty::onchange() const
{
    return _onchange;
}

void ModelProperty::setOnchange(const QString &onchange)
{
    _onchange = onchange;
}

QString ModelProperty::description() const
{
    return _description;
}

void ModelProperty::setDescription(const QString &description)
{
    _description = description;
}

ModelBlock *ModelProperty::parent() const
{
    return _parent;
}

void ModelProperty::setParent(ModelBlock *parent)
{
    _parent = parent;
    foreach (ModelProperty *property, _properties)
    {
        property->setParent(_parent);
    }
}

QList<ModelProperty *> &ModelProperty::properties()
{
    return _properties;
}

const QList<ModelProperty *> &ModelProperty::properties() const
{
    return _properties;
}

void ModelProperty::addProperty(ModelProperty *property)
{
    _properties.append(property);
}

QList<ModelPropertyEnum *> &ModelProperty::propertyEnums()
{
    return _propertyEnums;
}

const QList<ModelPropertyEnum *> &ModelProperty::propertyEnums() const
{
    return _propertyEnums;
}

void ModelProperty::addPropertyEnum(ModelPropertyEnum *propertyEnum)
{
    _propertyEnums.append(propertyEnum);
}

ModelProperty *ModelProperty::fromNodeGenerated(const QDomElement &domElement)
{
    ModelProperty *blockProperty=new ModelProperty();

    blockProperty->setName(domElement.attribute("name","no_name"));
    blockProperty->setCaption(domElement.attribute("caption",blockProperty->name()));
    if(blockProperty->caption().isEmpty()) blockProperty->setCaption(blockProperty->name());
    blockProperty->setType(domElement.attribute("type",""));
    blockProperty->setValue(domElement.attribute("value",""));
    blockProperty->setMin(domElement.attribute("min",""));
    blockProperty->setMax(domElement.attribute("max",""));
    blockProperty->setStep(domElement.attribute("step","1"));
    blockProperty->setAssert(domElement.attribute("assert",""));
    blockProperty->setPropertymap(domElement.attribute("propertymap",""));
    blockProperty->setOnchange(domElement.attribute("onchange",""));
    blockProperty->setDescription(domElement.attribute("desc",""));

    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="properties") blockProperty->_properties.append(ModelProperty::listFromNodeGenerated(e));
            if(e.tagName()=="enums") blockProperty->_propertyEnums.append(ModelPropertyEnum::listFromNodeGenerated(e));
        }
        n = n.nextSibling();
    }

    return blockProperty;
}

QList<ModelProperty *> ModelProperty::listFromNodeGenerated(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    QList<ModelProperty *> list;
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="property") list.append(ModelProperty::fromNodeGenerated(e));
        }
        n = n.nextSibling();
    }
    return list;
}
