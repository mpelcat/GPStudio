#include "propertyenumwidget.h"

#include <QVBoxLayout>
#include <QComboBox>
#include <QDebug>

PropertyEnumWidget::PropertyEnumWidget()
{
}

PropertyEnumWidget::~PropertyEnumWidget()
{
}

PropertyWidget::Type PropertyEnumWidget::type() const
{
    return Field;
}

void PropertyEnumWidget::createWidget()
{
    QVBoxLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);

    _comboBox = new QComboBox();

    QHashIterator<QString, QVariant> i(_linkedProperty->enums());
    while (i.hasNext())
    {
        i.next();
        _comboBox->addItem(i.key(), i.value());
    }

    connect(_comboBox, SIGNAL(currentIndexChanged(int)), this, SLOT(wrapValue(int)));
    connect(this, SIGNAL(valueChanged(QVariant)), _linkedProperty, SLOT(setValue(QVariant)));
    connect(_linkedProperty, SIGNAL(valueChanged(QVariant)), this, SLOT(setValue(QVariant)));

    layout->addWidget(_comboBox);

    setLayout(layout);
}

void PropertyEnumWidget::destroyWidget()
{
}

void PropertyEnumWidget::setValue(QVariant value)
{
    int index = _comboBox->findData(value);
    qDebug()<<"combo"<<value<<index;
    if(index!=-1)
    {
        _comboBox->blockSignals(true);
        _comboBox->setCurrentIndex(index);
        _comboBox->blockSignals(false);
    }
}

void PropertyEnumWidget::wrapValue(int value)
{
    emit(valueChanged(_comboBox->itemData(value)));
}
