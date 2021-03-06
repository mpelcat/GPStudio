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

#ifndef PROPERTYBOOLWIDGET_H
#define PROPERTYBOOLWIDGET_H

#include "gpstudio_gui_common.h"

#include "propertywidget.h"

class QCheckBox;

class GPSTUDIO_GUI_EXPORT PropertyBoolWidget : public PropertyWidget
{
    Q_OBJECT
public:
    PropertyBoolWidget();
    virtual ~PropertyBoolWidget();

    Type type() const;

protected:
    virtual void createWidget();
    virtual void destroyWidget();

public slots:
    virtual void setValue(QVariant value);

protected slots:
    void wrapValue(bool value);

private:
    QCheckBox *_checkBox;
};

#endif // PROPERTYBOOLWIDGET_H
