#include "propertymatrixwidget.h"

#include <QGridLayout>
#include <QSpinBox>
#include <QDebug>
#include <QGroupBox>

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
    QLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);
    QGroupBox *groupBox = new QGroupBox(_linkedProperty->caption());

    QGridLayout *layoutMatrix = new QGridLayout();
    layoutMatrix->setContentsMargins(0,0,0,0);

    for(int x=0; x<9; x++)
    {
        int find=0;
        for(int y=0; y<_linkedProperty->value().toInt(); y++)
        {
            Property *property = _linkedProperty->subProperties().propertiesMap()[QString("m%1%2").arg(x).arg(y)];
            if(property)
            {
                PropertyWidget *propertyWidget = PropertyWidget::getWidgetFromProperty(property);
                layoutMatrix->addWidget(propertyWidget,x,y);
                find++;
            }
        }
        if(find==0) break;
    }

    groupBox->setLayout(layoutMatrix);
    layout->addWidget(groupBox);
    setLayout(layout);
}

void PropertyMatrixWidget::destroyWidget()
{

}

void PropertyMatrixWidget::setValue(QVariant value)
{
    Q_UNUSED(value)
}
