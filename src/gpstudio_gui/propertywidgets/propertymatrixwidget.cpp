#include "propertymatrixwidget.h"

#include <QGridLayout>
#include <QSpinBox>
#include <QDebug>

PropertyMatrixWidget::PropertyMatrixWidget()
{
}

PropertyMatrixWidget::~PropertyMatrixWidget()
{

}

PropertyWidget::Type PropertyMatrixWidget::type() const
{
    return Group;
}

void PropertyMatrixWidget::createWidget()
{
    QGridLayout *layout = new QGridLayout();
    layout->setContentsMargins(0,0,0,0);

    for(int x=0; x<9; x++)
    {
        int find=0;
        for(int y=0; y<_linkedProperty->value().toInt(); y++)
        {
            Property *property = _linkedProperty->subProperties().propertiesMap()[QString("m%1%2").arg(x).arg(y)];
            if(property)
            {
                PropertyWidget *propertyWidget = PropertyWidget::getWidgetFromProperty(property);
                layout->addWidget(propertyWidget,x,y);
                find++;
            }
        }
        if(find==0) break;
    }

    setLayout(layout);
}

void PropertyMatrixWidget::destroyWidget()
{

}

void PropertyMatrixWidget::setValue(QVariant value)
{
    Q_UNUSED(value)
}
