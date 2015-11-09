#include "propertyboolwidget.h"

#include <QBoxLayout>
#include <QVBoxLayout>
#include <QCheckBox>
#include <QDebug>

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

    _checkBox = new QCheckBox(_linkedProperty->caption());
    connect(_checkBox, SIGNAL(toggled(bool)), _linkedProperty, SLOT(setValue(bool)));
    connect(_linkedProperty, SIGNAL(valueChanged(QVariant)), this, SLOT(setValue(QVariant)));
    layout->addWidget(_checkBox);

    setLayout(layout);

    setValue(_linkedProperty->value());
}

void PropertyBoolWidget::destroyWidget()
{
}

void PropertyBoolWidget::setValue(QVariant value)
{
    if(value.canConvert(QVariant::Bool))
    {
        _checkBox->blockSignals(true);
        _checkBox->setChecked(value.toBool());
        _checkBox->blockSignals(false);
    }
}
