#include "propertygroupwidget.h"

#include <QBoxLayout>
#include <QGroupBox>
#include <QFormLayout>
#include <QLabel>

PropertyGroupWidget::PropertyGroupWidget()
{
}

PropertyGroupWidget::~PropertyGroupWidget()
{
}

PropertyWidget::Type PropertyGroupWidget::type() const
{
    return Group;
}

void PropertyGroupWidget::createWidget()
{
    QLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);
    QGroupBox *groupBox = new QGroupBox(_linkedProperty->caption());

    QFormLayout *layoutPanel = new QFormLayout();
    layoutPanel->setFieldGrowthPolicy(QFormLayout::AllNonFixedFieldsGrow);
    layoutPanel->setSpacing(6);

    foreach (Property *property, _linkedProperty->subProperties().properties())
    {
        PropertyWidget *propertyWidget = PropertyWidget::getWidgetFromProperty(property);
        if(propertyWidget)
        {
            if(propertyWidget->type()==Field)
            {
                layoutPanel->addRow(property->caption(), propertyWidget);
            }
            else
            {
                layoutPanel->setWidget(layoutPanel->count(), QFormLayout::SpanningRole, propertyWidget);
            }
        }
    }

    groupBox->setLayout(layoutPanel);
    layout->addWidget(groupBox);
    setLayout(layout);
}

void PropertyGroupWidget::destroyWidget()
{
}

void PropertyGroupWidget::setValue(QVariant value)
{

}
