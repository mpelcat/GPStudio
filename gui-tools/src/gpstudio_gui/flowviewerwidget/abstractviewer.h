/****************************************************************************
** Copyright (C) 2014 Dream IP
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

#ifndef ABSTRACTVIEWER_H
#define ABSTRACTVIEWER_H

#include "gpstudio_gui_common.h"

#include <QWidget>

#include "camera/property.h"

class FlowViewerInterface;

class GPSTUDIO_GUI_EXPORT AbstractViewer : public QWidget
{
    Q_OBJECT
public:
    AbstractViewer(FlowViewerInterface *flowViewerInterface);

    const Property &properties() const;

public:
    static AbstractViewer *fromDataTypeName(const QString &dataTypeName);

protected:
    virtual void setupWidgets() =0;

protected:
    Property _properties;
};

#endif // ABSTRACTVIEWER_H
