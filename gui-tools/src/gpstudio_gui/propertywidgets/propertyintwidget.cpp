/****************************************************************************
** Copyright (C) 2016 Dream IP
** 
** This file is part of GPStudio.
**
** GPStudio is a free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program.  If not, see <http://www.gnu.org/licenses/>.
**
****************************************************************************/

#include "propertyintwidget.h"

#include <QVBoxLayout>
#include <QSpinBox>
#include <QDebug>

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
    if(_linkedProperty->isFixed() && _linkedProperty->mode()==Property::Run)
        _spinBox->setEnabled(false);
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
    if(value.canConvert(QVariant::Int))
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
