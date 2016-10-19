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

#include "propertyclockwidget.h"

#include <QVBoxLayout>
#include <QLineEdit>
#include <QDebug>
#include <QRegExpValidator>

PropertyClockWidget::PropertyClockWidget()
{
}

PropertyClockWidget::~PropertyClockWidget()
{
}

PropertyWidget::Type PropertyClockWidget::type() const
{
    return Field;
}

void PropertyClockWidget::createWidget()
{
    QVBoxLayout *layout = new QVBoxLayout();
    layout->setContentsMargins(0,0,0,0);

    _lineEdit = new QLineEdit();
    _lineEdit->setValidator(new QRegExpValidator(QRegExp("[0-9]+[kMG]{0,1}[Hz]{0,2}")));
    if(_linkedProperty->isFixed() && _linkedProperty->mode()==Property::Run)
        _lineEdit->setEnabled(false);

    connect(_lineEdit, SIGNAL(editingFinished()), this, SLOT(wrapValue()));
    connect(this, SIGNAL(valueChanged(QVariant)), _linkedProperty, SLOT(setValue(QVariant)));
    connect(_linkedProperty, SIGNAL(valueChanged(QVariant)), this, SLOT(setValue(QVariant)));

    layout->addWidget(_lineEdit);

    setLayout(layout);

    setValue(_linkedProperty->value());
}

void PropertyClockWidget::destroyWidget()
{
}

void PropertyClockWidget::setValue(QVariant value)
{
    if(value.canConvert(QVariant::Int))
    {
        _lineEdit->blockSignals(true);
        int freq = value.toInt();
        if(freq > 1000000000)
            _lineEdit->setText(QString("%1GHz").arg(freq/1000000000));
        else if(freq > 1000000)
            _lineEdit->setText(QString("%1MHz").arg(freq/1000000));
        else if(freq > 1000)
            _lineEdit->setText(QString("%1kHz").arg(freq/1000));
        _lineEdit->blockSignals(false);
    }
}

void PropertyClockWidget::wrapValue()
{
    bool ok;
    int mult = 1;
    QString typicalStr = _lineEdit->text();
    if(typicalStr.contains("G", Qt::CaseInsensitive))
        mult = 1000000000;
    if(typicalStr.contains("M", Qt::CaseInsensitive))
        mult = 1000000;
    if(typicalStr.contains("k", Qt::CaseInsensitive))
        mult = 1000;
    typicalStr.replace("GgMmKk","");
    int typical = typicalStr.toInt(&ok);
    if(ok)
        emit valueChanged(typical * mult);
}
