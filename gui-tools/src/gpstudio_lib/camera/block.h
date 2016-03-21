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

#ifndef BLOCK_H
#define BLOCK_H

#include "gpstudio_lib_common.h"

#include "property.h"

#include <QString>

class Flow;

class ModelBlock;

/**
 * @brief The Block class is part of the run time model and represent a block with the list of flow interfaces
 */
class GPSTUDIO_LIB_EXPORT Block
{
public:
    Block();

    QString name() const;

    const QList<Flow *> &flows() const;
    Flow *flow(int i) const;
    Flow *flow(QString name) const;

    Property *assocProperty() const;

    const ModelBlock *modelBlock() const;

protected:
    void setName(const QString &name);

public:
    static Block *fromModelBlock(const ModelBlock *modelBlock);

protected:
    QString _name;

    QList<Flow*> _flows;
    QMap<QString, Flow*> _flowsMap;

    Property *_assocProperty;

    const ModelBlock *_modelBlock;
};

#endif // BLOCK_H
