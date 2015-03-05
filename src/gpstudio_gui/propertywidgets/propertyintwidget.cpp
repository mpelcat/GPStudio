#include "propertyintwidget.h"

#include <QVBoxLayout>
#include <QSpinBox>

PropertyIntWidget::PropertyIntWidget()
{
}

PropertyIntWidget::~PropertyIntWidget()
{
}

PropertyWidget::Type PropertyIntWidget::type() const
{
    return Field;
}

void PropertyIntWidget::createWidget()
{
    QVBoxLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);

    QSpinBox *spinBox = new QSpinBox();
    spinBox->setMinimum(_linkedProperty->min().toInt());
    spinBox->setMaximum(_linkedProperty->max().toInt());

    layout->addWidget(spinBox);

    setLayout(layout);
}

void PropertyIntWidget::destroyWidget()
{
}
