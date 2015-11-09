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

    _spinBox = new QSpinBox();
    _spinBox->setMinimum(_linkedProperty->min().toInt());
    _spinBox->setMaximum(_linkedProperty->max().toInt());
    _spinBox->setSingleStep(_linkedProperty->step().toInt());

    connect(_spinBox, SIGNAL(editingFinished()), this, SLOT(wrapValue()));
    connect(this, SIGNAL(valueChanged(QVariant)), _linkedProperty, SLOT(setValue(QVariant)));
    connect(_linkedProperty, SIGNAL(valueChanged(QVariant)), this, SLOT(setValue(QVariant)));

    layout->addWidget(_spinBox);

    setLayout(layout);

    setValue(_linkedProperty->value());
}

void PropertyIntWidget::destroyWidget()
{
}

void PropertyIntWidget::setValue(QVariant value)
{
    if(value.type()==QVariant::Int)
    {
        _spinBox->blockSignals(true);
        _spinBox->setValue(value.toInt());
        _spinBox->blockSignals(false);
    }
}

void PropertyIntWidget::wrapValue()
{
    emit valueChanged(_spinBox->value());
}
