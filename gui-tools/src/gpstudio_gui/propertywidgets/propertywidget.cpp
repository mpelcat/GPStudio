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
    default:
        qDebug()<<"unknow prop type"<<(int)property->type();
        break;
    }
    if(widget) widget->setLinkedProperty(property);
    return widget;
}
