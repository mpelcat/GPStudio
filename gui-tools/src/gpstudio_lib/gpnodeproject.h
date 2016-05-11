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

#ifndef GPNODEPROJECT_H
#define GPNODEPROJECT_H

#include "gpstudio_lib_common.h"

#include "model/model_node.h"

class GPSTUDIO_LIB_EXPORT GPNodeProject
{
public:
    GPNodeProject();
    ~GPNodeProject();

    QString name() const;
    void setName(const QString &name);

private:
    QString _name;

    ModelNode *_node;
};

#endif // GPNODEPROJECT_H
