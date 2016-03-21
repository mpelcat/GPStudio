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

#include "propertywidget.h"

#include <QDebug>

#include "propertywidgets.h"

PropertyWidget::PropertyWidget()
{
    _linkedProperty = NULL;
}

PropertyWidget::~PropertyWidget()
{

}

Property *PropertyWidget::linkedProperty() const
{
    return _linkedProperty;
}

void PropertyWidget::setLinkedProperty(Property *linkedProperty)
{
    destroyWidget();

    if(_linkedProperty)
    {

    }

    _linkedProperty = linkedProperty;

    if(_linkedProperty)
    {

        createWidget();
    }
}

PropertyWidget *PropertyWidget::getWidgetFromProperty(Property *property)
{
    PropertyWidget *widget = NULL;
    //Group, Int, Enum
    switch (property->type())
    {
    case Property::Group:
    case Property::BlockType:
        widget = new PropertyGroupWidget();
        break;
    case Property::Int:
        widget = new PropertyIntWidget();
        break;
    case Property::SInt:
        widget = new PropertySIntWidget();
        break;
    case Property::Bool:
        widget = new PropertyBoolWidget();
        break;
    case Property::Enum:
        widget = new PropertyEnumWidget();
        break;
    case Property::Matrix:
        widget = new PropertyMatrixWidget();
        break;
    case Property::FlowType:
        widget = NULL;
        break;
    default:
        qDebug()<<"unknow prop type"<<(int)property->type();
        break;
    }
    if(widget) widget->setLinkedProperty(property);
    return widget;
}
