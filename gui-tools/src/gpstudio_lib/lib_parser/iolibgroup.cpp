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

#include "iolibgroup.h"

IOLibGroup::IOLibGroup(const QString &name)
    : _name(name)
{
}

IOLibGroup::~IOLibGroup()
{
}

QString IOLibGroup::name() const
{
    return _name;
}

void IOLibGroup::setName(const QString &name)
{
    _name = name;
}

bool IOLibGroup::isOptional() const
{
    return _optional;
}

void IOLibGroup::setOptional(bool isOptional)
{
    _optional = isOptional;
}

const QStringList &IOLibGroup::ios() const
{
    return _ios;
}

void IOLibGroup::addIos(const QString &name)
{
    _ios.append(name);
}


