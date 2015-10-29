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

    int i=0;
    qDebug()<<_linkedProperty->value().toInt();
    for(int x=0; x<3; x++)
    {
        for(int y=0; y<_linkedProperty->value().toInt(); y++)
        {
            qDebug()<<QString("m%1%2").arg(x).arg(y);
            Property *property = _linkedProperty->subProperties().propertiesMap()[QString("m%1%2").arg(x).arg(y)];
            if(property)
            {
                qDebug()<<"prop";
                PropertyWidget *propertyWidget = PropertyWidget::getWidgetFromProperty(property);
                layout->addWidget(propertyWidget,x,y);
            }
        }
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
