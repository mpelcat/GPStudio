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

#include "model_board.h"

#include "model_block.h"

ModelBoard::ModelBoard()
{
}

QString ModelBoard::name() const
{
    return _name;
}

void ModelBoard::setName(const QString &name)
{
    _name = name;
}

ModelBoard *ModelBoard::fromNodeGenerated(const QDomElement &domElement)
{
    ModelBoard *attribute = new ModelBoard();

    attribute->setName(domElement.attribute("name","no_name"));

    return attribute;
}

ModelBoard *ModelBoard::fromNodeDef(const QDomElement &domElement)
{
    ModelBoard *attribute = new ModelBoard();

    attribute->setName(domElement.attribute("name","no_name"));

    return attribute;
}

QList<ModelBlock *> ModelBoard::listIosFromNodeDef(const QDomElement &domElement)
{
    QDomNode n = domElement.firstChild();
    while(!n.isNull())
    {
        QDomElement e = n.toElement();
        if(!e.isNull())
        {
            if(e.tagName()=="ios")
                return ModelBlock::listFromNodeDef(e);
        }
    }
    return QList<ModelBlock *>();
}
