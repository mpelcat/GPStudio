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

#ifndef TCLSYNTAX_H
#define TCLSYNTAX_H

#include "gpstudio_gui_common.h"

#include "abstractsyntax.h"

class GPSTUDIO_GUI_EXPORT TCLSyntax : public AbstractSyntax
{
    Q_OBJECT
public:
    TCLSyntax(QTextDocument *parent = 0);

    static QStringList extensions() {return QStringList()<<"tcl"<<"sdc"<<"qsf"<<"qpf";}
};

#endif // TCLSYNTAX_H
