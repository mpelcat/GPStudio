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

#ifndef PROPERTYWIDGET_H
#define PROPERTYWIDGET_H

#include "gpstudio_gui_common.h"

#include <QWidget>

#include "camera/property.h"

class GPSTUDIO_GUI_EXPORT PropertyWidget : public QWidget
{
    Q_OBJECT
public:
    PropertyWidget();
    virtual ~PropertyWidget();

    Property *linkedProperty() const;
    virtual void setLinkedProperty(Property *linkedProperty);

    enum Type {Field, SimpleField, Group};
    virtual Type type() const =0;

public:
    static PropertyWidget *getWidgetFromProperty(Property *property);

protected:
    virtual void createWidget() =0;
    virtual void destroyWidget() =0;

signals:
    void valueChanged(QVariant value);

public slots:
    virtual void setValue(QVariant value) =0;

protected:
    Property *_linkedProperty;
};

#endif // PROPERTYWIDGET_H
