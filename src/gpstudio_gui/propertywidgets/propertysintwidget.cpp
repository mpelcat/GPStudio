#include "propertysintwidget.h"

#include <QVBoxLayout>
#include <QSlider>
#include <QLabel>

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

    QSlider *slider = new QSlider();
    slider->setMinimum(_linkedProperty->min().toInt());
    slider->setMaximum(_linkedProperty->max().toInt());
    slider->setValue(_linkedProperty->value().toInt());
    slider->setOrientation(Qt::Horizontal);
    layout->addWidget(slider);

    QLabel *label = new QLabel();
    label->setNum(_linkedProperty->value().toInt());
    connect(slider, SIGNAL(sliderMoved(int)), label, SLOT(setNum(int)));
    layout->addWidget(label);

    setLayout(layout);
}

void PropertySIntWidget::destroyWidget()
{
}
