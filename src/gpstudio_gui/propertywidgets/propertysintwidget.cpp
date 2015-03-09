#include "propertysintwidget.h"

#include <QVBoxLayout>
#include <QSlider>
#include <QLabel>
#include <QDebug>

PropertySIntWidget::PropertySIntWidget()
{
}

PropertySIntWidget::~PropertySIntWidget()
{
}

PropertyWidget::Type PropertySIntWidget::type() const
{
    return Field;
}

void PropertySIntWidget::createWidget()
{
    QHBoxLayout *layout = new QHBoxLayout();
    layout->setContentsMargins(0,0,0,0);

    _slider = new QSlider();
    _slider->setMinimum(_linkedProperty->min().toInt());
    _slider->setMaximum(_linkedProperty->max().toInt());
    _slider->setValue(_linkedProperty->value().toInt());
    _slider->setOrientation(Qt::Horizontal);
    layout->addWidget(_slider);

    connect(_slider, SIGNAL(valueChanged(int)), _linkedProperty, SLOT(setValue(int)));
    connect(_linkedProperty, SIGNAL(valueChanged(QVariant)), this, SLOT(setValue(QVariant)));

    _label = new QLabel();
    _label->setNum(_linkedProperty->value().toInt());
    connect(_slider, SIGNAL(sliderMoved(int)), _label, SLOT(setNum(int)));
    layout->addWidget(_label);

    setLayout(layout);
}

void PropertySIntWidget::destroyWidget()
{
}

void PropertySIntWidget::setValue(QVariant value)
{
    if(value.type()==QVariant::Int)
    {
        _slider->blockSignals(true);
        _slider->setValue(value.toInt());
        _label->setNum(value.toInt());
        _slider->blockSignals(false);
    }
}
