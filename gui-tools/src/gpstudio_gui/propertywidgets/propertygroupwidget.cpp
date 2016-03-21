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

    foreach (Property *property, _linkedProperty->subPropertiesMap())
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
    Q_UNUSED(value)
}
