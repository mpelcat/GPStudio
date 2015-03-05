#include "propertyboolwidget.h"

#include <QBoxLayout>
#include <QVBoxLayout>
#include <QCheckBox>

PropertyBoolWidget::PropertyBoolWidget()
{
}

PropertyBoolWidget::~PropertyBoolWidget()
{
}

PropertyWidget::Type PropertyBoolWidget::type() const
{
    return SimpleField;
}

void PropertyBoolWidget::createWidget()
{
    QBoxLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);

    layout->addWidget(new QCheckBox(_linkedProperty->caption()));

    setLayout(layout);
}

void PropertyBoolWidget::destroyWidget()
{
}
